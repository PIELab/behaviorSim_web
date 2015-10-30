draw_selected_graph = () ->
    # draws a sparkline graph for the selected node
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))
    el = $('#'+node_sparkline_id(model_builder.selected_node))
    try
        vals = simulator.get_node_values(model_builder.selected_node)
        if vals.length < 1
            throw Error('empty value list')

        timescale = $('#timescale-selector input:radio:checked').val()
        switch timescale
            when "hour"
                ts = vals[0..60]
                $("#graph-label-min").html("0m")
                $("#graph-label-max").html("60m")
            when "day"
                ts = vals[0..24]
                $("#graph-label-min").html("00:00")
                $("#graph-label-max").html("24:00")
            when "week"
                ts = vals[0..6]
                $("#graph-label-min").html("Monday")
                $("#graph-label-max").html("Sunday")
            else
                ts = vals
                $("#graph-label-min").html("0%")
                $("#graph-label-max").html("100%")

        # this is a custom workaround for button persistance in too early version of bootstrap TODO: update bootstrap, remove this:
        $('#timescale-selector input:radio').parent().parent().removeClass('active')
        $('#timescale-selector input:radio:checked').parent().parent().toggleClass('active')

        el.sparkline(ts, sparkline_options)
    catch error
        if error.message.split(':')[0] == "node not found! " || error.message == 'empty value list' || error.message == "formulation or assumption not set for node"
            console.log("node not yet specified; not drawing simulation.")
            insert_dummy_graph(el)
        else
            throw error


$(document).on("selectNodeChange", (evt) -> draw_selected_graph())
$(document).on('selectNode', (evt) -> draw_selected_graph())

# on change timescale, redraw
$("#timescale-selector label").on('click', (evt) ->
    draw_selected_graph()
)

# this is a hack to make the radio buttons work. updating the bootstrap css should eliminate the need for this. TODO: update css, remove this
$("#timescale-selector div").hide()
