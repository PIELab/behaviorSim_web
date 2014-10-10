### script for controlling responsive modeling param form ###

model_selector = document.getElementById("model-selector")

$listen model_selector, 'change', =>
    model_builder.selected_node_model = model_selector.value
    $('#modeling-options-form').html(model_builder.get_selected_node_form())

# initial setting of the content section
#model_builder.selected_node_model = model_selector.value
$('#modeling-options-form').html(model_builder.get_selected_node_form())


###
submit_button = document.getElementById('submit_node_button')

$listen submit_button, 'click', =>
    model_type = model_selector.value

    model_options = $('.model-option')
    selection = []
    for i in [0..model_options.length-1] by 1
        selection += model_options[i].value

    # post the new node info to the server
    $.post '/node_spec/submit',
        type: 'construct'
        model: model_type
        options: selection
        (data) -> window.location.reload(false)
###