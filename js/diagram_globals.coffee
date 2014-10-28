# interaction events:
@model_changed_event = new Event  # fires whenever model changes
@node_selection_changed = new Event  # fires when different node is selected
@graph_display_settings_changed_event = new Event  # fires when settings for the infoFlow graph changes
@model_complete_event = new Event  # fires whenever the model is completed (re-fires when model changes and is complete)

model_is_complete = () ->
    # returns true if model is complete, else false
    # TODO: this is broken now; fix it.
    if simulator._model.node_count == simulator._model.node_count  # basic check: completed count == total node count
        return true
    else
        return false

check_for_complete_model = () ->
    # checks if the model is complete and fires the model_complete_event if needed
    if model_is_complete()
        model_complete_event.trigger()
        return
    else
        return
model_changed_event.add_action(check_for_complete_model) 
        
@model_builder = new ModelBuilder
@simulator = new Simulator(model_builder._model, model_builder._graph)

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
