### script for controlling responsive modeling param form ###
source_type_selector = document.getElementById('source-type-selector')
source_options = document.getElementById('source-options')

$listen = (target, name, callback) ->
    # shortcut addListener function
    if target.addEventListener
        target.addEventListener name, callback, false
    else
        target.attachEvent "on#{name}", callback

$ getOptionsForSourceType = (selected) ->
    # returns html with options section for given selection
    if selected == 'personality'
        return '''
                <strong>Assuming a normal distribution,</strong>
                <br><br>
                <form>
                    mu = <input type="text" name="mu" class='model-option'>
                    sigma = <input type="text" name="sigma" class='model-option'>
                </form>
            '''
    else if selected == 'context'
        return '''
                <strong>Enter a comma-separated list of environmental influences.</strong>
                <form>
                    <input type="textarea" name="dep-list" class='model-option'>
                </form>
            '''
    else
        return "unrecognized selection '"+selected+"'"

$listen source_type_selector, 'change', =>
    source_options.innerHTML = getOptionsForSourceType( source_type_selector.value )

# initial setting of the content section
source_options.innerHTML = getOptionsForSourceType( source_type_selector.value )

### submit button ###
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