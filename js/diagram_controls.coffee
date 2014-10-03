### diagramophone controls ###

goBtn = document.getElementById("diagramophone")
textarea = document.getElementById("textarea")
repl = document.getElementById("replBtn")
fontBtn = document.getElementById("fontBtn")
saveBtn = document.getElementById("saveIt")
raphaelCanvas = document.getElementById("canvas")


$listen goBtn, 'click', => draw_colored_graph(textarea.value, paper, fontBtn.checked)
$listen saveBtn, 'click', => @controller.saveAllTheThings(raphaelCanvas)

$listen textarea, 'keyup', =>
    if (repl.checked)
        draw_colored_graph(textarea.value, paper, fontBtn.checked)

$listen fontBtn, 'change', =>
    draw_colored_graph(textarea.value, paper, fontBtn.checked)

# initialize the view
textarea.value = sampleText
draw_colored_graph(textarea.value, paper, fontBtn.checked)

### this is the model inserter button ###
insertbutton = document.getElementById("submodel_inserter")
modelselector= document.getElementById("submodel_selector")

$listen submodel_inserter, 'click', =>
    if submodel_selector.value == 'TPB'
        textarea.value+='\n behavioral attitude -> intention \n subjective norms -> intention \n perceived behavioral control -> intention \n perceived behavioral control -> behavior \n intention -> behavior \n'
        draw_colored_graph(textarea.value, paper, fontBtn.checked)
    else
        console.log('unrecognized submodel value "'+submodel_selector.value+'"')

window.Drawer.click_node = (node_id) ->
    graph.set_selected_node(node_id)
