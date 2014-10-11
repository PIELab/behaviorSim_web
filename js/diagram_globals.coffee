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
        if model_builder._graph.getParentsOf(model_builder.selected_node).length > 0
            model_builder.selected_node_model = $('#model-selector').val()
        else
            model_builder.selected_node_model = $('#source-type-selector').val()

    node_selection_changed.trigger()

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

window.update_assumption_preset = () ->
    ###
    updates the calculation method used on the current node using the value of the 'calculator-preset' element
    ###
    # TODO: set model thing?
    model_builder.submit_node()
