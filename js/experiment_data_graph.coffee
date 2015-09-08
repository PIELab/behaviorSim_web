getFakeData = () ->
    timescale = $('#timescale-selector input:radio:checked').val()
    switch timescale
        when "hour"
            return [0]*60
        when "day"
            return [0,0,0,0,0,0,0,0,300,156,0,100,623,0,212,80,0,528,200,0,83,210,0 ,0]
                   #  1 2 3 4 5 6 7 8   9   10 11 12  1   2 3  4  5  6   7 8  9   10 11
        when "week"
            return [2190,1500,1400,1200,1000,1900,1600,1589]
        else
            return [0,1,0]

draw_fake_data_graph = () ->
    # draws a sparkline graph for the selected node
    #$('#experiment-data-graph').html(get_node_graph_html(model_builder.selected_node))  # TODO: this should be something else...
    el = $('#experiment-data-graph')
    vals = getFakeData()
    if vals.length < 1
        throw Error('empty value list')

    el.sparkline(vals, sparkline_options)

$('#do-expmt-btn').on('click', draw_fake_data_graph)