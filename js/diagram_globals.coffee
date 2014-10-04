@controller = new Controller

window.paper = Raphael "canvas", 800, 600

window.graph = new Graph;
window.graph.selected_node = 'Verbal_Persuasion'
window.graph.completed_nodes = []
window.graph.selected_node_model = 'context'

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

    # redraw the graph
    draw_colored_graph(textarea.value, paper, fontBtn.checked)

    update_selected_node_texts()
    update_selected_node_details()

    $('.selected_node_functional_form').html(graph.get_selected_node_functional_form())

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

