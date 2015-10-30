$listen document.getElementById('source-type-selector'), 'change', =>
    $(document).trigger("selectNodeChange")

$listen document.getElementById("model-selector"), 'change', =>
    $(document).trigger("selectNodeChange")

$listen document.getElementById("calculator-preset"), 'change', =>
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
                    model_builder._init_slider_and_box("low",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "low", true, 0)
                    )
                    model_builder._init_slider_and_box("high",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "high", true, 1)
                    )
                    model_builder._init_slider_and_box("step_time",
                        model_builder.get_node_assumption_argument(model_builder.selected_node,"step_time", true)
                    )
                    if err
                        console.log(err))
        when 'random_walk'
            dust.render("random_walk",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("scale",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "scale", true, 1)
                    )
                    if err
                        console.log(err))
        when 'constant'
            dust.render("parameter_tweak",
                {param_name:"value", option_type:"inflow-assertion", valu:1},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("value",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "value", true, 1)
                    )
                    if err
                        console.log(err))
        when 'square'
            dust.render("square",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    model_builder._init_slider_and_box("low",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "low", true, 0)
                    )
                    model_builder._init_slider_and_box("high",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "high", true, 1)
                    )
                    model_builder._init_slider_and_box("dt",
                        model_builder.get_node_assumption_argument(model_builder.selected_node, "dt", true)
                    )
                    if err
                        console.log(err))
        when 'upload'
            dust.render("upload",
                {},
                (err, out) =>
                    # update the html
                    form.html(out)
                    if err
                        console.log(err)
            )

        when 'manual'
            timescale = $('#timescale-selector input:radio:checked').val()
            series_len = 100
            switch timescale
                when 'day'
                    series_len = 24
                when 'week'
                    series_len = 7
            try
                lastSeries = "[" + model_builder.get_node_assumption_argument(model_builder.selected_node, "values", false).toString() + "]" #"[1,2,3]"
            catch err
                console.log('reverting to default manual entry')
                lastSeries = "[1,2,3]"
            dust.render("manual",
                        {
                            length:series_len,
                            currentSeries: lastSeries
                        },
                        (err, out) =>
                            # update the html
                            form.html(out)
                            if err
                                console.log(err)
            )

        else
            form.html('ERR')
            console.log('unknown preset: ', $('#calculator-preset').val())
            throw Error('unkown calculator preset')



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
        when 'personality-var-options'
            $('#modeling-spec').hide()
            $('#source-spec').show()
            $('#assumption-options').hide()
        else
            form.html('ERR')
            console.log('unknown model type:', model_builder.get_selected_node_type())
            throw Error('what model type is this?')

    model_builder.update_selected_node_form()

$(document).on("selectNodeChange_highestP", (evt) -> update_modeling_options_form())
$(document).on("graphChange", (evt) -> update_modeling_options_form())
$(document).on('selectNode', (evt) -> update_modeling_options_form())

init_node_function_value = (eventObj) ->
    try
        $('option[value="'+model_builder._model.get_node(model_builder.selected_node).assumption.type+'"]').attr("selected", "selected")
    catch err
        console.log('assumption not yet set, preset box not filled')
$(document).on("selectNode", init_node_function_value)
