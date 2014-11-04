sparkline_options = {type: 'line', height: '4em', width: '100%'}

insert_dummy_graph = (el) ->
    dummy_data = [1,2,3,4,6,8,2,5,8,3,4,9,1,2,5,4,6,8,9,0,1,2,4,7,2,4]
    el.sparkline(dummy_data, sparkline_options)
    $('#selected-node-graph').append('<div style="top:10%; left:0; height:90%; width:100%; background:white; opacity:.8; position:absolute; z-index:9;"></div><div style="top:40%; left:10%; z-index:10; position:absolute">sample only.<br>specify node to simulate.</div>')

draw_selected_graph = () ->
    # draws a sparkline graph for the selected node
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))
    el = $('#'+node_sparkline_id(model_builder.selected_node))
    vals = simulator.get_node_values(model_builder.selected_node)
    try
        if vals.length < 1
            throw Error('empty value list')
        el.sparkline(vals, sparkline_options)
    catch error
        if error.message.split(':')[0] == "node not found! " || error.message == 'empty value list'
            console.log("node not yet specified; not drawing simulation.")
            insert_dummy_graph(el)
        else
            throw error


$(document).on("selectNodeChange", (evt) -> draw_selected_graph())
$(document).on('selectNode', (evt) -> draw_selected_graph())
