%# TPL PARAMS:
%# simManager
%# CONFIG

### script for controlling responsive modeling param form ###

modelingOptions = document.getElementById('modeling-options')
model_selector = document.getElementById("model-selector")

$listen = (target, name, callback) ->
    # shortcut addListener function
    if target.addEventListener
        target.addEventListener name, callback, false
    else
        target.attachEvent "on#{name}", callback

$ getOptionsForSelection = (selected) ->
    # returns html with options section for given selection
    if selected == 'linear-combination'
        return '''
                <strong>{{simManager.selected_node.name}} = 
					% for parent in simManager.selected_node.parents:
						+ c_{{parent.name}}*{{parent.name}}
					% end
				</strong>
                <br><br>
                <form>
					% for parent in simManager.selected_node.parents:
						c_{{parent.name}} = <input type="text" name="c_{{parent.name}}" class='model-option'> <br>
					% end
                </form>
            '''
    else if selected == 'fluid-flow'
        return '''
                <strong>tao_{{simManager.selected_node.name}}*d{{simManager.selected_node.name}}/dt = {{simManager.selected_node.name}}
                    % for parent in simManager.selected_node.parents:
						+ c_{{parent.name}}*{{parent.name}}(t - theta_{{parent.name}})
					% end
				</strong>
                <form>
                    tao_{{simManager.selected_node.name}} = <input type="text" name="tao_{{simManager.selected_node.name}}" class='model-option'> <br>
                    % for parent in simManager.selected_node.parents:
						c_{{parent.name}} = <input type="text" name="c_{{simManager.selected_node.name}}_{{parent.name}}" class='model-option'> <br>
						theta_{{parent.name}} = <input type="text" name="theta_{{simManager.selected_node.name}}_{{parent.name}}" class='model-option'> <br>
					% end
                </form>
            '''
    else if selected == 'other'
        return '''
                <strong> constr2 = f( ctx2 ) </strong
                <form>
                    <input type="paragraph" name="code" class='model-option'>
                </form>
            '''
    else
        return "unrecognised selection '"+selected+"'"

$listen model_selector, 'change', =>
    modelingOptions.innerHTML = getOptionsForSelection( model_selector.value )

# initial setting of the content section
modelingOptions.innerHTML = getOptionsForSelection( model_selector.value )

### submit button ###
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