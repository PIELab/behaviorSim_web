model_selector = document.getElementById("model-selector")
source_type_selector = document.getElementById('source-type-selector')

$listen source_type_selector, 'change', =>
    model_changed_event.trigger()

$listen model_selector, 'change', =>
    model_changed_event.trigger()

update_modeling_options_form = () ->
    # updates the node spec details widget
    if model_builder._model.get_parents_of(model_builder.selected_node).length > 0
        $('#modeling-spec').show()
        $('#source-spec').hide()
    else
        $('#modeling-spec').hide()
        $('#source-spec').show()

    $('#modeling-options-form').html(model_builder.get_selected_node_form())

model_changed_event.add_action(update_modeling_options_form)
node_selection_changed.add_action(update_modeling_options_form)
