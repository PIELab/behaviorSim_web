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

    # update the graphic
    draw_colored_graph(textarea.value, paper, fontBtn.checked)

window.graph.set_selected_node = (node_id) ->
    window.graph.selected_node = node_id

    # redraw the infoflow graph
    draw_colored_graph(textarea.value, paper, fontBtn.checked)

    # update various texts
    update_selected_node_texts()
    update_selected_node_details()
    $('.selected_node_functional_form').html(graph.get_selected_node_functional_form())

    # update parent graphs
    draw_parent_graphs()
    draw_selected_graph()

window.graph.get_selected_node_form = () ->
    _result = ''
    if graph.selected_node_model == 'linear-combination'
        for parent of graph.getNode(graph.selected_node)._inEdges
            _result += 'c_' + parent + ' = <input type="text" name="c_' + parent + '" class="model-option-linear"><br>'
        return _result
    else if graph.selected_node_model == 'fluid-flow'
        _result += 'tao_' + graph.selected_node + ' = <input type="text" name="tao_'
        _result += graph.selected_node + '" class="model-option-fluid-flow"> <br>'
        for parent of graph.getNode(graph.selected_node)._inEdges
            _result += 'c_'+parent+' = <input type="text" '+'name="c_'
            _result += graph.selected_node+'_'+parent+'" class="model-option-fluid-flow"><br>theta_'+parent
            _result += ' = <input type="text" name="theta_'+graph.selected_node+'_'+parent
            _result += '" class="model-option-fluid-flow"><br>'
        return _result
    else if graph.selected_node_model == 'other'
        _result += 'define your function in javascript<br>'
        _result += '<input type="textarea" name="'+graph.selected_node
        _result += '_func" style="width:100%" rows="17"></input>'

    else
        console.log('ERR: unknown node form "'+graph.selected_node_model+'"')

window.graph.get_selected_node_functional_form = () ->
    lhs = graph.selected_node + "("  # left hand side
    rhs = ""  # right hand side

    if graph.selected_node_model == 'linear-combination'
        for parent of graph.getNode(graph.selected_node)._inEdges
            lhs += parent + ', '
            rhs += 'c_'+parent+'*'+parent+'(t) +'
        lhs += 't)'
        rhs = rhs[0..rhs.length-2]  # trim off last plus
        return (lhs + ' = ' + rhs)
    else if graph.selected_node_model == 'fluid-flow'
        rhs += 'tao_' + graph.selected_node + '*d' + graph.selected_node + '/dt =' + graph.selected_node
        for parent of graph.getNode(graph.selected_node)._inEdges
            rhs += '+ c_' + parent + '*' + parent + '(t - theta_' + parent + ')'
        lhs += 't)'
        return (lhs + ' = ' + rhs)
    else if graph.selected_node_model == 'other'
        for parent of graph.getNode(graph.selected_node)._inEdges
            lhs += parent + ', '
        lhs += 't)'
        return (lhs + ' = ')
    else
        console.log('ERR: unknown node model "'+graph.selected_node_model+'"')

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

window.draw_selected_graph = () ->
    $('#selected-node-graph').html(get_node_graph_html(graph.selected_node))
    n_parents = graph.getParentsOf(graph.selected_node).length
    if n_parents <= 0
        if graph.selected_node_model == 'context-var-options'
            $('#selected-node-graph').append('TODO: preset dropdowns')
        else if graph.selected_node_model == 'personality-var-options'
            $('#selected-node-graph').append('TODO: show dist. w/ rand selection highlighted and set calculator to const')
        else
            throw Error('unparented node type unrecognized: '+graph.selected_node_model)
        try
            $('#'+node_sparkline_id(graph.selected_node)).sparkline(simulator.get_node_values(graph.selected_node))
        catch error
            console.log(error)
            $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
    else
        try
            $('#'+node_sparkline_id(graph.selected_node)).sparkline(simulator.get_node_values(graph.selected_node))
        catch error
            console.log(error)
            $('#selected-node-graph').append('! ~ node & inflows must be specified first ~ !<br>')

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
                $('#'+node_sparkline_id(parent)).sparkline(simulator.get_node_values(parent))
            catch error
                $('#parent-graphs').append('!!! ~ node not yet defined ~ !!!<br>')
    else
        $('#parent-graphs').append(graph.selected_node+' has no inflow nodes.')
