
draw_selected_graph = () ->
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))

    node_type = model_builder.get_selected_node_type()

    switch node_type
        when 'context-var-options'
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(
                    simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
                $('#selected-node-graph').append('<select id="calculator-preset" data-placeholder="select preset..." class="chosen-select" style="width:250px;" tabindex="4" onclick="update_assumption_preset()"> <option value="random_walk">random_walk</option> <option value="constant">constant</option>  </select>')
            catch error
                console.log("node not yet spec'd, no big deal.")
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'personality-var-options'
            $('#selected-node-graph').append('TODO: show dist. w/ rand selection highlighted and set calculator to const')
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node must be specified first ~ !<br>')
        when 'state'
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                console.log(error)
                $('#selected-node-graph').append('! ~ node & inflows must be specified first ~ !<br>')
        else
            throw Error('node type unrecognized: '+node_type)

model_changed_event.add_action(draw_selected_graph)
node_selection_changed.add_action(draw_selected_graph)