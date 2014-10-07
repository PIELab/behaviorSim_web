@controller = new Controller

window.paper = Raphael "canvas", 800, 600

window.graph = new Graph;
window.graph.selected_node = 'Verbal_Persuasion'
window.graph.completed_nodes = []
window.graph.selected_node_model = 'context-var-options'

window.simulator = new Simulator(model_builder._model, graph)

window.sampleText = """
Verbal_Persuasion -> Self_Efficacy
Vicarious_Experience -> Self_Efficacy
Self_Efficacy -> Physical_Activity_Level
"""

window.$listen = (target, name, callback) ->
    if target
        if target.addEventListener
            target.addEventListener name, callback, false
        else
            target.attachEvent "on#{name}", callback
    else
        console.log('cannot listen for '+name+' on '+target+' with '+callback)

window.submit_node_spec = () ->
    model_builder.submit_node()

    # reset node to reload graphs and stuff
    graph.set_selected_node(graph.selected_node)

window.build_graph_obj = (dsl_text) ->
    for line in textarea.value.split('\n')
        stmt = line.split('->')
        n1 = stmt[0].replace(' ', '')
        n2 = stmt[1].replace(' ', '')
        graph.addNode(n1)
        graph.addNode(n2)
        graph.addEdge(n1, n2);

window.draw_colored_graph = (inputText, paper, hasSillyFont) ->
    # update the js graph object
    build_graph_obj(inputText)

    # desired color to selected node
    inputText += '\n' + graph.selected_node + ' {#2488DF}'  # 0->blue
    # and completed nodes
    for node in graph.completed_nodes
        if node == graph.selected_node # if node is completed and selected
            inputText = inputText.replace(node+ ' {#2488DF}',  node + ' {#199E7C}')  # blue->teal
        else
            inputText += '\n' + node + ' {#00A900}'  # 0->green

    # call the main method
    @controller.makeItGo(inputText, paper, fontBtn.checked)

window.complete_a_node = (node_id) ->
    window.graph.completed_nodes.push(node_id)
    $('#completed-node-list').html(graph.completed_nodes)


    # TODO: the following should be implemented as listeners to the 'selected-node-name' element id
    # update the graphic
    draw_colored_graph(textarea.value, paper, fontBtn.checked)
    
window.graph.set_selected_node = (node_id) ->
    window.graph.selected_node = node_id
    try
        graph.selected_node_model = simulator.get_node_object(graph.selected_node).type
    catch error  # node not found
        graph.selected_node_model = 'personality-var-options'

    $('#selected-node-name').html(graph.selected_node)
    $('#selected-node-type').html(get_node_type(graph.selected_node))
    $('#selected-node-model').html(graph.selected_node_model)
    $('#selected-node-parents').html(graph.getParentsOf(graph.selected_node))
    $('#completed-node-list').html(graph.completed_nodes)
    
    # update various texts
    update_selected_node_texts()
    update_selected_node_details()
    $('.selected_node_functional_form').html(graph.get_selected_node_functional_form())
    
    # TODO: the following should be implemented as listeners to the 'selected-node-name' element id
    # redraw the infoflow graph
    draw_colored_graph(textarea.value, paper, fontBtn.checked)
    
    $('#modeling-options-form').html(graph.get_selected_node_form())

    # update parent graphs
    draw_parent_graphs()
    draw_selected_graph()

window.graph.get_selected_node_form = () ->
    _result = ''
    switch graph.selected_node_model 
        when 'linear-combination'
            for parent of graph.getNode(graph.selected_node)._inEdges
                _result += 'c_' + parent + ' = <input type="text" name="c_' + parent + '" class="model-option-linear"><br>'
        when 'fluid-flow'
            _result += 'tao_' + graph.selected_node + ' = <input type="text" name="tao_'
            _result += graph.selected_node + '" class="model-option-fluid-flow"> <br>'
            for parent of graph.getNode(graph.selected_node)._inEdges
                _result += 'c_'+parent+' = <input type="text" '+'name="c_'
                _result += graph.selected_node+'_'+parent+'" class="model-option-fluid-flow"><br>theta_'+parent
                _result += ' = <input type="text" name="theta_'+graph.selected_node+'_'+parent
                _result += '" class="model-option-fluid-flow"><br>'
        when 'other'
            _result += 'define your function in javascript<br>'
            _result += '<input type="textarea" name="'+graph.selected_node
            _result += '_func" style="width:100%" rows="17"></input>'
        when 'context-var-options'
            _result += 'Enter a comma-separated list of environmental influences. <input type="textarea" name="dep-list" class="model-option-context">'
        when 'personality-var-options'
            _result += 'Assuming a normal distribution across the population,<br> mu = <input type="text" name="mu" class="model-option-personality"><br>sigma = <input type="text" name="sigma" class="model-option-personality">'
        else
            throw Error('unknown node form "'+graph.selected_node_model+'"')
    return _result

window.graph.get_selected_node_functional_form = () ->
    lhs = graph.selected_node + "("  # left hand side
    rhs = ""  # right hand side

    switch graph.selected_node_model
        when 'linear-combination'
            for parent of graph.getNode(graph.selected_node)._inEdges
                lhs += parent + ', '
                rhs += 'c_'+parent+'*'+parent+'(t) +'
            lhs += 't)'
            rhs = rhs[0..rhs.length-2]  # trim off last plus
        when 'fluid-flow'
            rhs += 'tao_' + graph.selected_node + '*d' + graph.selected_node + '/dt =' + graph.selected_node
            for parent of graph.getNode(graph.selected_node)._inEdges
                rhs += '+ c_' + parent + '*' + parent + '(t - theta_' + parent + ')'
            lhs += 't)'
        when 'other'
            for parent of graph.getNode(graph.selected_node)._inEdges
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
            throw Error('unknown node model "'+graph.selected_node_model+'"')
            
    return lhs + ' = ' + rhs

node_sparkline_id = (node_id) ->
   # returns element id for given node id
   return ''+node_id+'_sparkline'

get_node_graph_html = (node_id) ->
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
    n_parents = graph.getParentsOf(node_id).length
    if n_parents <= 0  # source node
        if graph.selected_node_model == 'context-var-options'
            return 'context-var-options'
        else if graph.selected_node_model == 'personality-var-options'
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
    $('#selected-node-graph').html(get_node_graph_html(graph.selected_node))
    
    node_type = get_node_type(graph.selected_node)
    
    switch node_type 
        when 'context-var-options'
            try
                $('#'+node_sparkline_id(graph.selected_node)).sparkline(
                    simulator.get_node_values(graph.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
                $('#selected-node-graph').append('<select id="calculator-preset" data-placeholder="select preset..." class="chosen-select" style="width:250px;" tabindex="4" onclick="update_assumption_preset()"> <option value="random_walk">random_walk</option> <option value="constant">constant</option>  </select>')
            catch error
                console.log("node not yet spec'd, no big deal.")
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'personality-var-options'
            $('#selected-node-graph').append('TODO: show dist. w/ rand selection highlighted and set calculator to const')
            try
                $('#'+node_sparkline_id(graph.selected_node)).sparkline(simulator.get_node_values(graph.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'state'
            try
                $('#'+node_sparkline_id(graph.selected_node)).sparkline(simulator.get_node_values(graph.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node & inflows must be specified first ~ !<br>')
        else
            throw Error('node type unrecognized: '+graph.selected_node_model)
        

window.draw_parent_graphs = () ->
    ###
    inserts parent graphs into parent graph widget
    ###
    # clear old html
    $('#parent-graphs').html('<div class="box-header">Mini-simulation: '+graph.selected_node+"'s parents.</div>")

    parents = graph.getParentsOf(graph.selected_node)
    if parents.length > 0
        # insert parent graphs
        for parent in parents
            try
                $('#parent-graphs').append(get_node_graph_html(parent))
                $('#'+node_sparkline_id(parent)).sparkline(
                    simulator.get_node_values(parent),
                    {type: 'line', height: '2em', width: '100%'})
            catch error
                $('#parent-graphs').append('!!! ~ node not yet defined ~ !!!<br>')
    else
        $('#parent-graphs').append(graph.selected_node+' has no inflow nodes.')
