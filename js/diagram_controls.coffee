### diagramophone controls ###
controller = new Controller
the_paper = Raphael "canvas", 800, 600
sampleText = """
proximityOfDarcy -> desireToEatChocolate
environmentalStressors -> desireToEatChocolate
desireToEatChocolate -> chocolateConsumption
proximityOfChocolate -> chocolateConsumption
"""

goBtn = document.getElementById("diagramophone")
textarea = document.getElementById("textarea")
repl = document.getElementById("replBtn")
fontBtn = document.getElementById("fontBtn")

$listen goBtn, 'click', => $(document).trigger("graphChange")

$listen textarea, 'keyup', =>
    if (repl.checked)
        $(document).trigger("graphChange")

$listen fontBtn, 'change', =>
    draw_colored_graph()

window.click_node = (node_id) ->
    model_builder.set_selected_node(node_id)
    $(document).trigger('selectNode')

draw_colored_graph = (inputText=textarea.value, paper=the_paper, hasSillyFont=fontBtn.checked) ->
    # update the js graph object
    model_builder.build_graph_obj(inputText )
    $(document).trigger('graphModelUpdated');

    # desired color to selected node
    inputText += '\n' + model_builder.selected_node + ' {#2488DF}'  # 0->blue
    # and completed nodes
    for nodeId of model_builder._model.nodes
        if model_builder._model.nodes[nodeId].formulation  # if node is complete
            if nodeId == model_builder.selected_node # if node is completed and selected
                inputText = inputText.replace(nodeId+ ' {#2488DF}',  nodeId + ' {#199E7C}')  # blue->teal
            else
                inputText += '\n' + nodeId + ' {#00A900}'  # 0->green

    # call the main method
    controller.makeItGo(inputText, paper, fontBtn.checked)

$(document).on("graphChange", (evt) -> draw_colored_graph())
$(document).on('selectNode', (evt) -> draw_colored_graph())

# initialize the view
textarea.value = sampleText
draw_colored_graph()

# submit the node automatically when selected unless already set
$(document).on('selectNode', (evt) ->
    try
        node = model_builder.get_node(model_builder.selected_node)
        if model_builder.node_is_complete(node)
            #console.log('it is done')
            return
        else
            #console.log('submitting')
            $(document).trigger('selectNodeChange')
    catch err
        if err.message == 'node not found'
            console.log('err submitting on select; selected node not found:', model_builder.selected_node)
        else
            throw err
)

# resubmit node when changes are made
$(document).on("selectNodeChange_higherP", (evt) -> model_builder.submit_node())

# add mouseover popup to the nodes
$("#canvas").on("mouseover", ".diagramophone-node-text", (evt) ->
    #console.log(evt.target.innerHTML, ' hovered: ', @)
    #console.log($(@))
    $(@).popover({
        container: @,
        content:"test"#"<a href='#node-spec-box'><i class='fa fa-cog'></i>Formulate Inflow</a>",
        # TODO use html: insead of content: ?
        placement: "auto below",
        # TODO title: evt.target.innerHTML
        trigger: 'manual'
    })
    $(@).popover('show')
)
