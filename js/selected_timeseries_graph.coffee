sparkline_options = {type: 'line', height: '4em', width: '100%'}

insert_dummy_graph = (el) ->
    dummy_data = [1,2,3,4,6,8,2,5,8,3,4,9,1,2,5,4,6,8,9,0,1,2,4,7,2,4]
    el.sparkline(dummy_data, sparkline_options)
    $('#selected-node-graph').append('<div style="top:10%; left:0; height:90%; width:100%; background:white; opacity:.8; position:absolute; z-index:9;"></div><div style="top:40%; left:10%; z-index:10; position:absolute">sample only.<br>specify node to simulate.</div>')

draw_selected_graph = () ->
    $('#selected-node-graph').html(get_node_graph_html(model_builder.selected_node))
    el = $('#'+node_sparkline_id(model_builder.selected_node))

    node_type = model_builder.get_selected_node_type()
    switch node_type
        when 'context-var-options'
            try
                vals = simulator.get_node_values(model_builder.selected_node)
                if vals.length < 1
                    throw Error('empty value list')
                el.sparkline(vals, sparkline_options)
            catch error
                if error.message.split(':')[0] == "node not found! " || error.message == 'empty value list'
                    console.log("context node not yet specified; not drawing simulation.")
                    insert_dummy_graph(el)
                else
                    throw error
            $('#assumption-options-selector').html('<select id="calculator-preset" style="width:250px;" tabindex="4"> <option value="random_walk">random walk</option> <option value="constant">constant value</option> <option value="step">step function</option> <option value="square">square wave</option> </select>')
            try
                $('option[value="'+model_builder._model.get_node(model_builder.selected_node).assumption.type+'"]').attr("selected", "selected")
            catch err 
                console.log('assumption not yet set, preset box not filled')
            $listen(document.getElementById('calculator-preset'), 'change', () ->
                vvv = $('#calculator-preset').val()
                console.log('new selection:', vvv)
                switch vvv
                    when 'random_walk'
                        assumption = {type:'random_walk', calculator: simulator.calculator_random_walk, arguments: {scale: 10, initial_value:5}}
                    when 'constant'
                        assumption = {type:'constant', calculator: simulator.calculator_constant, arguments: {value: 1}}
                    when 'step'
                        assumption = {type:'step', calculator: simulator.calculator_step, arguments: {low:-1, high:1, step_time:5}}
                    when 'square'
                        assumption = {type:'square', calculator: simulator.calculator_square, arguments: {low:-1, high:1, dt:5}}
                    else
                        throw Error('unknown calculator-preset value')
                        
                model_builder.set_node_assumption(model_builder.selected_node, assumption)
            )
            
        when 'personality-var-options'
            try
                vals = simulator.get_node_values(model_builder.selected_node)
                if vals.length < 1
                    throw Error('empty value list')
                el.sparkline(vals, sparkline_options)
            catch error
                if error.message.split(':')[0] == "node not found! " || error.message == 'empty value list'
                    console.log('personality node not yet specified; not drawing simulation')
                    insert_dummy_graph(el)
                else
                    throw error
        when 'state'
            try
                $('#'+node_sparkline_id(model_builder.selected_node)).sparkline(simulator.get_node_values(model_builder.selected_node),
                    {type: 'line', height: '4em', width: '100%'})
            catch error
                if error.message.split(':')[0] == 'node not found! '
                    console.log('state node not yet specified; not drawing simulation')
                    insert_dummy_graph(el)
                else
                    throw error
        else
            throw Error('node type unrecognized: '+node_type)

model_changed_event.add_action(draw_selected_graph)
node_selection_changed.add_action(draw_selected_graph)