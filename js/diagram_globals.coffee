# interaction events:
@model_changed_event = new Event
@node_selection_changed = new Event
@graph_display_settings_changed_event = new Event

window.simulator = new Simulator(model_builder._model, model_builder._graph)

window.$listen = (target, name, callback) ->
    ###
    Helper function to make assigning listeners easy
    ###
    if target
        if target.addEventListener
            target.addEventListener name, callback, false
        else
            target.attachEvent "on#{name}", callback
    else
        console.log('cannot listen for '+name+' on '+target+' with '+callback)

window.submit_node_spec = () ->
    ###
    submits node specification from web form
    ###
    model_builder.submit_node()

    model_changed_event.trigger()

    # TODO: replace this call with event listeners elsewhere
    model_builder.set_selected_node(model_builder.selected_node)

window.complete_a_node = (node_id) ->
    window.model_builder.completed_nodes.push(node_id)
    $('#completed-node-list').html(model_builder.completed_nodes)

    model_changed_event.trigger()

model_builder.set_selected_node = (node_id) ->
    model_builder.selected_node = node_id
    try
        model_builder.selected_node_model = simulator.get_node_object(model_builder.selected_node).type
    catch error  # node not found
        # default model selection:
        model_builder.selected_node_model = 'personality-var-options'

    # ==================================================================
    # set all of the data debugging elements
    # ==================================================================
    $('#selected-node-name').html(model_builder.selected_node)
    $('#selected-node-type').html(get_node_type(model_builder.selected_node))
    $('#selected-node-model').html(model_builder.selected_node_model)
    $('#selected-node-parents').html(model_builder._graph.getParentsOf(model_builder.selected_node))
    $('#completed-node-list').html(model_builder.completed_nodes)
    # personality spec details
    try
        $('#personality-spec_sigma').html(simulator.get_node_spec_parameter(model_builder.selected_node, 'sigma'))
        $('#personality-spec_mu').html(simulator.get_node_spec_parameter(model_builder.selected_node, 'mu'))
    catch error
        # simulator could not find node (or param?)
        $('#personality-spec_sigma').html('undefined')
        $('#personality-spec_mu').html('undefined')
        
        # TODO: maybe this should be more proactive... like:
        ###
        # set it
        model_builder.submit_node()
        # try again
        model_builder.set_selected_node(node_id)
        ###
    
    # ==================================================================
    # update various texts
    # ==================================================================
    update_selected_node_details()
    $('.selected_node_functional_form').html(model_builder.get_selected_node_functional_form())
    
    # ==================================================================
    # TODO: the following should be implemented as listeners to model_changed_event
    $('#modeling-options-form').html(model_builder.get_selected_node_form())


window.model_builder.get_selected_node_form = () ->
    _result = ''
    switch model_builder.selected_node_model
        when 'linear-combination'
            for parent of model_builder._graph.getNode(model_builder.selected_node)._inEdges
                _result += 'c_' + parent + ' = <input type="text" name="c_' + parent + '" class="model-option-linear"><br>'
        when 'fluid-flow'
            _result += 'tao_' + model_builder.selected_node + ' = <input type="text" name="tao_'
            _result += model_builder.selected_node + '" class="model-option-fluid-flow"> <br>'
            for parent of model_builder._graph.getNode(model_builder.selected_node)._inEdges
                _result += 'c_'+parent+' = <input type="text" '+'name="c_'
                _result += model_builder.selected_node+'_'+parent+'" class="model-option-fluid-flow"><br>theta_'+parent
                _result += ' = <input type="text" name="theta_'+model_builder.selected_node+'_'+parent
                _result += '" class="model-option-fluid-flow"><br>'
        when 'other'
            _result += 'define your function in javascript<br>'
            _result += '<input type="textarea" name="'+model_builder.selected_node
            _result += '_func" style="width:100%" rows="17"></input>'
        when 'context-var-options'
            _result += 'Enter a comma-separated list of environmental influences. <input type="textarea" name="dep-list" class="model-option-context">'
        when 'personality-var-options'
            _result += 'Assuming a normal distribution across the population,<br> mu = <input type="text" name="mu" class="model-option-personality"><br>sigma = <input type="text" name="sigma" class="model-option-personality">'
        else
            throw Error('unknown node form "'+model_builder.selected_node_model+'"')
    return _result

window.model_builder.get_selected_node_functional_form = () ->
    lhs = model_builder.selected_node + "("  # left hand side
    rhs = ""  # right hand side

    switch model_builder.selected_node_model
        when 'linear-combination'
            for parent of model_builder._graph.getNode(model_builder.selected_node)._inEdges
                lhs += parent + ', '
                rhs += 'c_'+parent+'*'+parent+'(t) +'
            lhs += 't)'
            rhs = rhs[0..rhs.length-2]  # trim off last plus
        when 'fluid-flow'
            rhs += 'tao_' + model_builder.selected_node + '*d' + model_builder.selected_node + '/dt =' + model_builder.selected_node
            for parent of model_builder._graph.getNode(model_builder.selected_node)._inEdges
                rhs += '+ c_' + parent + '*' + parent + '(t - theta_' + parent + ')'
            lhs += 't)'
        when 'other'
            for parent of model_builder._graph.getNode(model_builder.selected_node)._inEdges
                lhs += parent + ', '
            lhs += 't)'
            rhs = 'f()'
        when 'constant'
            lhs += ')'
            rhs += 'C'
        when 'context-var-options'
            lhs += 't)'
            rhs += 'f(context(t))'
        when 'personality-var-options'
            lhs += ')'
            rhs += 'gauss(mu, sigma)'
        else
            throw Error('unknown node model "'+model_builder.selected_node_model+'"')
            
    return lhs + ' = ' + rhs

window.node_sparkline_id = (node_id) ->
   # returns element id for given node id
   return ''+node_id+'_sparkline'

window.get_node_graph_html = (node_id) ->
    ###
    returns html for a given node id
    ###
    html = node_id+'<br><div class="sparkline" id="'+node_sparkline_id(node_id)+'"'
    html += ' data-type="line" data-spot-Radius="3" '
    html += ' data-highlight-Spot-Color="#f39c12" data-highlight-Line-Color="#222" '
    html += ' data-min-Spot-Color="#f56954" data-max-Spot-Color="#00a65a" '
    html += ' data-spot-Color="#39CCCC" data-offset="90" data-width="100%" '
    html += ' data-height="100px" data-line-Width="2" data-line-Color="#39CCCC" '
    html += ' data-fill-Color="rgba(57, 204, 204, 0.08)"> '
    html += ' </div> '
    return html

window.get_node_type = (node_id) ->
    ###
    returns a string indicating the type of the given node 
    ###
    n_parents = model_builder._graph.getParentsOf(node_id).length
    if n_parents <= 0  # source node
        if model_builder.selected_node_model == 'context-var-options'
            return 'context-var-options'
        else if model_builder.selected_node_model == 'personality-var-options'
            return 'personality-var-options'
        else
            return 'unknown-source'
    else  # state node
        return 'state'
        
window.update_assumption_preset = () ->
    ###
    updates the calculation method used on the current node using the value of the 'calculator-preset' element
    ###
    # TODO: set model thing?
    model_builder.submit_node()
