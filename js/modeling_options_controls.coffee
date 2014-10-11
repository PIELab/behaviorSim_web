model_selector = document.getElementById("model-selector")
source_type_selector = document.getElementById('source-type-selector')

$listen source_type_selector, 'change', =>
    model_builder.selected_node_model = source_type_selector.value
    model_changed_event.trigger()

$listen model_selector, 'change', =>
    model_builder.selected_node_model = model_selector.value
    model_changed_event.trigger()

update_modeling_options_form = () ->
    $('#modeling-options-form').html(model_builder.get_selected_node_form())

model_changed_event.add_action(update_modeling_options_form)
node_selection_changed.add_action(update_modeling_options_form)

