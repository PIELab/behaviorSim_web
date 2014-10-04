### script for controlling responsive modeling param form ###
source_type_selector = document.getElementById('source-type-selector')

# these NEED to match the id of each of their corresponding divs AND the selection box values
source_model_option_sections = ['context-var-options', 'personality-var-options']

window.show_only_selected_source_node_options_div = (selection) ->
    for option in source_model_option_sections
        if option == selection
            $('#'+option).show()
        else
            $('#'+option).hide()

$listen source_type_selector, 'change', =>
    graph.selected_node_model = source_type_selector.value
    show_only_selected_source_node_options_div( graph.selected_node_model )

# initial setting of the content section
show_only_selected_source_node_options_div( source_type_selector.value )



###
submit_button = document.getElementById('submit_node_button')

$listen submit_button, 'click', =>
    model_type = 'TODO: REPLACE THIS'

    model_options = $('.model-option')
    selection = []
    for i in [0..model_options.length-1] by 1
        selection += model_options[i].value

    # post the new node info to the server
    $.post '/node_spec/submit',
        type: source_type_selector.value
        model: model_type
        options: selection
        (data) -> window.location.reload(false)
###