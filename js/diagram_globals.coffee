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

    # color the nodes
    text = inputText

    # desired color to selected node
    newText = inputText.replace(graph.selected_node, graph.selected_node + ' {#2488DF}')
    # and completed nodes
    for node in graph.completed_nodes
        newText = newText.replace(node, node + ' {#00A900}')

    # call the main method
    @controller.makeItGo(newText, paper, fontBtn.checked)


window.graph.set_selected_node = (node_id) ->
    window.graph.selected_node = node_id

    # redraw the graph
    draw_colored_graph(textarea.value, paper, fontBtn.checked)

    update_selected_node_details()
    update_selected_node_texts()