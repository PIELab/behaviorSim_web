### diagramophone controls ###
controller = new Controller
the_paper = Raphael "canvas", 800, 600
sampleText = """
Verbal_Persuasion -> Self_Efficacy
Vicarious_Experience -> Self_Efficacy
Self_Efficacy -> Physical_Activity_Level
"""

goBtn = document.getElementById("diagramophone")
textarea = document.getElementById("textarea")
repl = document.getElementById("replBtn")
fontBtn = document.getElementById("fontBtn")

$listen goBtn, 'click', => model_changed_event.trigger()

$listen textarea, 'keyup', =>
    if (repl.checked)
        model_changed_event.trigger()

$listen fontBtn, 'change', =>
    graph_display_settings_changed_event.trigger()

### this is the model inserter button ###
insertbutton = document.getElementById("submodel_inserter")
modelselector= document.getElementById("submodel_selector")

$listen submodel_inserter, 'click', =>
    if submodel_selector.value == 'TPB'
        textarea.value+='\n behavioral attitude -> intention \n subjective norms -> intention \n perceived behavioral control -> intention \n perceived behavioral control -> behavior \n intention -> behavior \n'
        model_changed_event.trigger()
    else
        console.log('unrecognized submodel value "'+submodel_selector.value+'"')

window.click_node = (node_id) ->
    # TODO remove this & use listener below instead
    model_builder.set_selected_node(node_id)

    node_selection_changed.trigger()

draw_colored_graph = (inputText=textarea.value, paper=the_paper, hasSillyFont=fontBtn.checked) ->
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
    controller.makeItGo(inputText, paper, fontBtn.checked)

model_changed_event.add_action(draw_colored_graph)
node_selection_changed.add_action(draw_colored_graph)
graph_display_settings_changed_event.add_action(draw_colored_graph)

# initialize the view
textarea.value = sampleText
draw_colored_graph(textarea.value, the_paper, fontBtn.checked)  # TODO: remove this?