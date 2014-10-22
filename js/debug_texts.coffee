update_debug_texts = () ->
    # ==================================================================
    # set all of the data debugging elements
    # ==================================================================
    $('#selected-node-name').html(model_builder.selected_node)
    $('#selected-node-type').html(model_builder.get_selected_node_type())
    $('#selected-node-model').html(model_builder.get_node_model())
    $('#selected-node-parents').html(model_builder._model.get_parents_of(model_builder.selected_node))
    $('#completed-node-list').html(model_builder.completed_nodes)
    # personality spec details
    try
        $('#personality-spec_sigma').html(simulator.get_node_spec_parameter(model_builder.selected_node, 'sigma'))
        $('#personality-spec_mu').html(simulator.get_node_spec_parameter(model_builder.selected_node, 'mu'))
    catch error
        # simulator could not find node (or param?)
        $('#personality-spec_sigma').html('undefined')
        $('#personality-spec_mu').html('undefined')

model_changed_event.add_action(update_debug_texts)
node_selection_changed.add_action(update_debug_texts)