
update_modeling_options_form = () ->
    $('#modeling-options-form').html(model_builder.get_selected_node_form())

model_changed_event.add_action(update_modeling_options_form)
node_selection_changed.add_action(update_modeling_options_form)