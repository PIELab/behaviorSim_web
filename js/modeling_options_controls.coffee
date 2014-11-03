model_selector = document.getElementById("model-selector")
source_type_selector = document.getElementById('source-type-selector')

$listen source_type_selector, 'change', =>
    $(document).trigger("selectNodeChange")

$listen model_selector, 'change', =>
    $(document).trigger("selectNodeChange")

update_inflow_assertion_form = () ->
    # updates the inflow assertion part of the inflow spec
    form = $('#assumption-options-form')
    switch $('#calculator-preset').val()
        when 'step'
            dust.render("step",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("low", 1)
                    model_builder._init_slider_and_box("high", 10)
                    model_builder._init_slider_and_box("step_time", 20)
                    if err
                        console.log(err))
        when 'random_walk'
            dust.render("random_walk",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("scale", 2)
                    if err
                        console.log(err))
        when 'constant'
            dust.render("parameter_tweak",
                {param_name:"value", option_type:"inflow-assertion", valu:1},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("value", 1)
                    if err
                        console.log(err))
        when 'square'
            dust.render("square",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("low", 1)
                    model_builder._init_slider_and_box("high", 10)
                    model_builder._init_slider_and_box("frequency", 20)
                    if err
                        console.log(err))
        else
            form.html('ERR')
            console.log('unknown preset: ', $('#calculator-preset').val())
            throw Error('unkown calculator preset')


update_node_assumption = () ->
    switch $('#calculator-preset').val()
        when 'random_walk'
            assumption = {
                type:'random_walk',
                calculator: simulator.calculator_random_walk,
                arguments: {
                    scale: $('#scale-box').val(),
                    initial_value:5 # TODO: use $('initial-value-box').val()
                }
            }
        when 'constant'
            assumption = {
                type:'constant',
                calculator: simulator.calculator_constant,
                arguments: {
                    value: $('#value-box').val()
                }
            }
        when 'step'
            assumption = {
                type:'step',
                calculator: simulator.calculator_step,
                arguments: {
                    low: $('#low-box').val(),
                    high: $('#high-box').val(),
                    step_time: $('#step_time-box').val()
                }
            }
        when 'square'
            assumption = {
                type:'square',
                calculator: simulator.calculator_square,
                arguments: {
                    low: $('#low-box').val(),
                    high: $('#high-box').val(),
                    dt: $('#frequency-box').val()
                }
            }
        else
            throw Error('unknown calculator-preset value')

    model_builder.set_node_assumption(model_builder.selected_node, assumption)


update_modeling_options_form = () ->
    # updates the node spec details widget
    switch model_builder.get_selected_node_type()
        when 'state'
            $('#modeling-spec').show()
            $('#source-spec').hide()
            $('#assumption-options').hide()
        when 'context-var-options'
            $('#modeling-spec').hide()
            $('#source-spec').show()
            $('#assumption-options').show()
            update_inflow_assertion_form()
            update_node_assumption()
        when 'personality-var-options'
            $('#modeling-spec').hide()
            $('#source-spec').show()
            $('#assumption-options').hide()
        else
            form.html('ERR')
            console.log('unknown model type:', model_builder.get_selected_node_type())
            throw Error('what model type is this?')

    model_builder.update_selected_node_form()

$(document).on("selectNodeChange", (evt) -> update_modeling_options_form())
$(document).on("graphChange", (evt) -> update_modeling_options_form())
$(document).on('selectNode', (evt) -> update_modeling_options_form())
