draw_selected_graph = () ->
    # draws a sparkline graph for the selected node
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))
    el = $('#'+node_sparkline_id(model_builder.selected_node))
    try
        vals = simulator.get_node_values(model_builder.selected_node)
        if vals.length < 1
            throw Error('empty value list')
        el.sparkline(vals, sparkline_options)
    catch error
        if error.message.split(':')[0] == "node not found! " || error.message == 'empty value list' || error.message == "formulation or assumption not set for node"
            console.log("node not yet specified; not drawing simulation.")
            insert_dummy_graph(el)
        else
            throw error


$(document).on("selectNodeChange", (evt) -> draw_selected_graph())
$(document).on('selectNode', (evt) -> draw_selected_graph())
