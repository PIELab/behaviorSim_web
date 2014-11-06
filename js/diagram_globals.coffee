check_for_complete_model = () ->
    # checks if the model is complete and fires the model_complete_event if needed
    if model_builder.model_is_complete()
        $(document).trigger("modelComplete")
        return
    else
        return
$(document).on("selectNodeChange", (evt) -> check_for_complete_model())

@model_builder = new ModelBuilder
@simulator = new Simulator(model_builder._model, model_builder._graph)

# set up priority chain for selectNodeChange
$(document).on("selectNodeChange", (evt) -> $(document).trigger("selectNodeChange_highP"))
$(document).on("selectNodeChange_highP", (evt) -> $(document).trigger("selectNodeChange_higherP"))
$(document).on("selectNodeChange_higherP", (evt) -> $(document).trigger("selectNodeChange_highestP"))

# set simulator values to recalc when changes to node model are made (note: doesn't actually recalc, that comes later)
$(document).on("selectNodeChange_highestP", (evt) -> simulator.recalc(model_builder.selected_node))

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

window.submit_node_spec = () -> # TODO: replace this with calls directly to model_builder.submit_node()
    ###
    submits node specification from web form
    ###
    model_builder.submit_node()

window.node_sparkline_id = (node_id) ->
   # returns element id for given node id
   return ''+node_id+'_sparkline'

window.get_node_graph_html = (node_id) ->  # TODO: use a template for this...
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
