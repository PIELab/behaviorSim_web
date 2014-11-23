draw_parent_graphs = () ->
    ###
    inserts parent graphs into parent graph widget
    ###
    # clear old html
    $('#parent-graphs').html('<div class="box-header">Mini-simulation: '+model_builder.selected_node+"'s parents.</div>")

    parents = model_builder._model.get_parents_of(model_builder.selected_node)
    if parents.length > 0
        # insert parent graphs
        for parent in parents
            try
                $('#parent-graphs').append(get_node_graph_html(parent))
                $('#'+node_sparkline_id(parent)).sparkline(
                    simulator.get_node_values(parent),
                    {type: 'line', height: '2em', width: '100%'})
            catch error
                console.log('parent graphs not drawn :', error)
                graph_id = parent+'_time_series'
                $('#parent-graphs').append('<div class="box" id="'+graph_id+'"></div>')
                insert_dummy_graph($('#'+graph_id))
    else
        $('#parent-graphs').append(model_builder.selected_node+' has no inflow nodes.')
    return

$(document).on("graphModelReady", (evt) -> draw_parent_graphs())
$(document).on('selectNode', (evt) -> draw_parent_graphs())