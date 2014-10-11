@model_changed_event = new Event
@node_selection_changed = new Event

@controller = new Controller

window.paper = Raphael "canvas", 800, 600

window.simulator = new Simulator(model_builder._model, model_builder._graph)

window.sampleText = """
Verbal_Persuasion -> Self_Efficacy
Vicarious_Experience -> Self_Efficacy
Self_Efficacy -> Physical_Activity_Level
"""

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

window.draw_colored_graph = (inputText, paper, hasSillyFont) ->
    # update the js graph object
    model_builder.build_graph_obj(inputText )

    # desired color to selected node
    inputText += '\n' + model_builder.selected_node + ' {#2488DF}'  # 0->blue
    # and completed nodes
    for node in model_builder.completed_nodes
        if node == model_builder.selected_node # if node is completed and selected
            inputText = inputText.replace(node+ ' {#2488DF}',  node + ' {#199E7C}')  # blue->teal
        else
            inputText += '\n' + node + ' {#00A900}'  # 0->green

    # call the main method
    @controller.makeItGo(inputText, paper, fontBtn.checked)

window.complete_a_node = (node_id) ->
    window.model_builder.completed_nodes.push(node_id)
    $('#completed-node-list').html(model_builder.completed_nodes)


    # TODO: the following should be implemented as listeners to the 'selected-node-name' element id
    # update the graphic
    draw_colored_graph(textarea.value, paper, fontBtn.checked)
    
model_builder.set_selected_node = (node_id) ->
    model_builder.selected_node = node_id
    try
        model_builder.selected_node_model = simulator.get_node_object(model_builder.selected_node).type
    catch error  # node not found
        # default model selection:
        model_builder.selected_node_model = 'personality-var-options'

    # ==================================================================
    # set all of the data elements (which may trigger various listeners)
    # TODO: undo this... it doesn't work...
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
    update_selected_node_texts()
    update_selected_node_details()
    $('.selected_node_functional_form').html(model_builder.get_selected_node_functional_form())
    
    # ==================================================================
    # TODO: the following should be implemented as listeners to the 'selected-node-name' element id
    # redraw the infoflow graph
    draw_colored_graph(textarea.value, paper, fontBtn.checked)
    
    $('#modeling-options-form').html(model_builder.get_selected_node_form())

    # update parent graphs
    #draw_parent_graphs()

    draw_selected_graph()

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


window.draw_selected_graph = () ->
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))
    
    node_type = get_node_type(model_builder.selected_node)
    
    switch node_type 
        when 'context-var-options'
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(
                    simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
                $('#selected-node-graph').append('<select id="calculator-preset" data-placeholder="select preset..." class="chosen-select" style="width:250px;" tabindex="4" onclick="update_assumption_preset()"> <option value="random_walk">random_walk</option> <option value="constant">constant</option>  </select>')
            catch error
                console.log("node not yet spec'd, no big deal.")
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'personality-var-options'
            $('#selected-node-graph').append('TODO: show dist. w/ rand selection highlighted and set calculator to const')
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'state'
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node & inflows must be specified first ~ !<br>')
        else
            throw Error('node type unrecognized: '+model_builder.selected_node_model)
