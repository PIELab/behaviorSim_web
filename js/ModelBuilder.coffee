class ModelBuilder
    ###
    A generalized system model specification object for building a model JSON object.

    Properties:
    - nodeSize: total number of nodes.
    - edgeSize: total number of edges.
    ###
    constructor: (model) ->
        @_model = new Model
        @selected_node = 'Verbal_Persuasion'
        @completed_nodes = []

        @IRS_COUNTER = 0  # counter for ion range slider (why is this here?)

    get_node: (node_id) ->
        return @_model.get_node(node_id)

    get_node_model: (node_id) ->
        ###
        returns a string indicating the given node's model
        ###
        try
            selected_model = simulator.get_node_object(model_builder.selected_node).type
            switch selected_model
                when "state"
                    selected_model = simulator.get_node_object(model_builder.selected_node).formulation.type
                    if selected_model == undefined
                        throw Error('state node has not formulation type')
                when undefined
                    throw Error('simulator has no node type')
        catch error  # node (or type) not found
            # select a model using the html selector elements
            if model_builder._model.get_parents_of(model_builder.selected_node).length > 0
                selected_model = $('#model-selector').val()
            else
                selected_model = $('#source-type-selector').val()
        return selected_model
        
    submit_node: (nname=@get_node_name(), type=@get_selected_node_type(), parents=@get_node_parents(), children=@get_node_children(), formulation=@get_node_formulation()) ->
        ###
        accepts submission of node & updates or adds node spec if needed
        ###
        node = @add_node(nname, type, parents, children, formulation)
        @set_node_assumption(nname, @get_node_assumption_input(nname))
        simulator.recalc(nname)
        return node

    add_node: (nname=@get_node_name(), type=@get_selected_node_type(), parents=@get_node_parents(), children=@get_node_children(), formulation=@get_node_formulation()) ->
        ###
        adds a node to the model
        ###
        return @_model.update_node(nname, type, parents, children, formulation)

    get_node_name: () ->
        return @selected_node

    get_node_parents: () ->
        return @get_node(@selected_node).parents ? []

    get_node_children: () ->
        return @get_node(@selected_node).children ? []

    get_node_formulation: () ->
        node_type = @get_node_model(@selected_node)
        if node_type == 'context-var-options'
            return {
                type : "dependency_list"
                dependencies : $("input[name='dep-list']").val()
            }
        else if node_type == 'personality-var-options'
            return {
                type : "normal_distribution"
                mu : parseFloat($("input[name='mu']").val())
                sigma: parseFloat($("input[name='sigma']").val())
            }
        else if node_type == 'linear-combination'
            return @_add_modeling_options(
                {
                    type:"linear-combination",
                    calculator:simulator.calculator_linear_combination
                },
                '.model-option-linear-combination'
            )
        else if node_type == 'differential-equation'
            return @_add_modeling_options(
                {
                    type:"differential-equation",
                    calculator:simulator.calculator_differential_equation
                },
                '.model-option-differential-equation'
            )
        else if node_type == 'other'
            return {
                type : "general_formulation"
                formula: $("input[name='"+@selected_node+"_func']").val()
            }
        else
            throw Error('unknown node formulation req: '+node_type)

    set_selected_node: (node_id) ->
        model_builder.selected_node = node_id

    set_model: (new_model) ->
        ###
        sets the model to the given object
        ###
        # @_model = new_model_obj   # doesn't work here b/c of js "copy of a reference" behaviour
        #   causes reference of global model to be unaltered... we want to modify that (so simulator can see new model)
        # Clear all the 'old' properties from the object
        for prop in @_model
            delete @_model[prop]
        # Insert the new ones
        $.extend(@_model, new_model)
        
        # update the completed nodes list
        @completed_nodes = []
        for node of @_model.nodes
            if @_model.nodes[node].formulation
                @completed_nodes.push(node.name)
                
        # select the first node of the new model
        @selected_node = @_model.root_node.children[0]

        # update the dsl display
        $('#textarea').val(@get_model_dsl())
        
        console.log('model set to:', @_model)

    load_model: (file_loc) ->
        ###
        loads a model from a given json file location (presumably on server)
        ###
        $.ajax file_loc,
            success  : (data, status, xhr) =>
                @set_model(data)
        error    : (xhr, status, err) ->
            console.log(err)
        complete : (xhr, status) ->
            console.log("done loading model")

    get_model_dsl: () ->
        ###
        returns diagram specification languange (DSL) string for model.
        Assumes that all nodes are linked (no stray nodes)
        ###
        result = ''
        for node in @_model.nodes
            for child in node.children
                result += node.name + ' -> ' + child + '\n'

        return result

    build_graph_obj: (dsl_str) ->
        @_model.clear()
        for line in dsl_str.split('\n')
            line = line.split('//')[0]  # this ignores everything after a // (comments)
            if line == '' # ignore blank lines
                continue
            try
                stmt = line.split('->')  # split by arrow
                n1 = stmt[0].trim()
                @_model.add_node(n1)

                n2 = stmt[1].trim()
                @_model.add_node(n2)

                # console.log(n1, '->', n2)
                @_model.add_edge(n1, n2);
            catch error  # malformed line (no big deal)
                console.log('dsl parse error @: ', line)

        if @_model.node_count <= 0 # no nodes
            @_model.add_node('infoflow_graph_nodes_show_up_here...')
        else if @_model.node_count > 1 and @_model.nodes['infoflow_graph_nodes_here...']?
            delete @_model.nodes['infoflow_graph_nodes_here...']
            @_model.node_count -= 1  # TODO: where is the delete_node method???

        if ! @_model.nodes[@selected_node] and @_model.root_node.children.length > 0  # if selected node has been deleted
            @set_selected_node(@_model.root_node.children[0])
        return
                
    get_selected_node_functional_form: () ->
        ###
        returns a string showing the functional form of the selected node
        ###
        lhs = @selected_node + "("  # left hand side
        rhs = ""  # right hand side
        
        # attempt to create general equation (iteration 1 under diff-eq
        
        
        ###
        Note for future use of latex commands: use double backslashes (\\) as opposed
        to single (\) as the single is used as an escape character, so for example if we
        were to want tau in our equation, use \\tau and not \tau. 
        ###
        
        generalEquation = ""
    
        switch @get_node_model(@selected_node)
            when 'linear-combination'
                for parent in @get_node(@selected_node).parents
                    lhs += parent + ', '
                    rhs += 'c_'+parent+'*'+parent+'(t) +'
                lhs += 't)'
                rhs = rhs[0..rhs.length-2]  # trim off last plus
            when 'differential-equation'
            
                # generalEquation = "\\tau_{1}frac{deta{1}}{dt}"
            
                rhs += "\\tau_{" + @selected_node + '}*\\frac{d' + @selected_node + '}{dt} =' + @selected_node
                for parent in @get_node(@selected_node).parents
                    rhs += '+ c_{' + parent + '}*' + parent + '(t - \\theta_{' + parent + '})'
                lhs += 't)'
            when 'other'
                for parent in @get_node(@selected_node).parents
                    lhs += parent + ', '
                lhs += 't)'
                rhs = 'f()'
            when 'constant'
                lhs += ')'
                rhs += 'C'
            when 'context-var-options'
                lhs += 't)'
                rhs += 'f(context(t))'
            when 'personality-var-options'
                lhs += ')'
                rhs += 'gauss(mu, sigma)'
            else
                throw Error('unknown node model "'+@get_node_model(@selected_node)+'"')
    
        # return generalEquation
        return lhs + ' = ' + rhs

    node_is_complete: (node) ->
        ###
        returns true if the given node is considered fully specified
        ###
        if node.formulation? or node.assumption?
            return true
        else
            return false

    get_node_assumption_argument: (node_id, parameter_name, use_default=false, default_val) ->
        ###
        returns the value of the requested parameter for the given node.
        throws error if value doesn't exist && use_default is false,
        if use_default true returns default_val if given, default value from simulator otherwise.
        ###
        try
            val = @_model.get_node(node_id).assumption.arguments[parameter_name]
            if val?
                return val
            else
                throw Error('bad val')
        catch err
            if use_default
                if default_val?
                    return default_val
                else
                    return simulator._get_default_value()
            else
                throw err

	
    update_selected_node_form: () ->
        ###
        updates the modeling options form with a form used to specify the selected node
        ###
        _result = ''
        # clear existing html
        $('#modeling-options-form').html('')
        switch @get_node_model(@selected_node)
            when 'linear-combination'
                for parent in @get_node(@selected_node).parents
                    coeff = 'c_'+parent
                    c_val = simulator.get_node_spec_parameter(@selected_node, coeff, true, 1)
                    @_add_parameter_to_form(coeff, c_val, 'linear-combination', 0.1, 'coeff-tooltip')

            when 'differential-equation'
                tao = 'tao'
                tao_v = simulator.get_node_spec_parameter(@selected_node, tao, true, .5)
                @_add_parameter_to_form(tao, tao_v, 'differential-equation', 1, "tao-tooltip")

                for parent in @get_node(@selected_node).parents
                    coeff = 'c_'+parent
                    c_val = simulator.get_node_spec_parameter(@selected_node, coeff, true, 1)
                    @_add_parameter_to_form(coeff, c_val, 'differential-equation', 0.1, 'coeff-tooltip')
                    
                    theta = 'theta_'+parent
                    theta_val = simulator.get_node_spec_parameter(@selected_node, theta, true, 0)
                    @_add_parameter_to_form(theta, theta_val, 'differential-equation', 1, 'theta-tooltip')
            when 'other'
                _result = 'define your function in javascript<br>'
                _result += '<input type="textarea" name="'+@selected_node
                _result += '_func" style="width:100%" rows="17" value="function () {\n\n}"></input>'
                $('#modeling-options-form').html(_result)
            when 'context-var-options'
                # TODO: re-enable this?
                $('#modeling-options-form').html('')
                #$('#modeling-options-form').html('Enter a comma-separated list of environmental influences. <input type="textarea" name="dep-list" class="model-option-context">')
            when 'personality-var-options'
                $('#modeling-options-form').html('Assuming a normal distribution across the population,<br>')
                @_add_parameter_to_form('mu', simulator.get_node_spec_parameter(@selected_node, 'mu', true), 'personality')
                @_add_parameter_to_form('sigma', simulator.get_node_spec_parameter(@selected_node, 'sigma', true), 'personality')
            else
                throw Error('unknown node form "'+@get_node_model(@selected_node)+'"')
        return _result

    _add_parameter_to_form: (name, val, option_type, sliderStepSize=0.1, tooltipClass="") ->

        dust.render("parameter_tweak",
            {param_name: name, valu: val, option_type: option_type},
            (err, out) =>
                # update the html
                $('#modeling-options-form').append(out)
                @_init_slider_and_box(name, val, sliderStepSize)
                if err
                    console.log(err))

        $(document).trigger('popoverRender');

    _init_slider_and_box: (coeff, c_val, sliderStepSize=0.1) ->  #TODO: this should be someplace that makes more sense
        ###
        inits the drawing of the slider and links the box and slider using jquery events
        ###
        @IRS_COUNTER += 1
        c_val = parseFloat(c_val)
        slider = $("#"+coeff+"-slider")
        box = $("#"+coeff+"-box")
        box.val(c_val)

        # should get exactly 1 box and 1 slider
        if slider.length + box.length != 2
            console.log('box:', box, '\nslider:', slider)
            throw 'malformed box and slider jquery!'

        # init the new slider
        slider.ionRangeSlider({
            min: c_val-10.0,
            max: c_val+10.0,
            from: c_val,
            type: 'single',
            step: sliderStepSize,
            prettify: false,
            hasGrid: true,
            onChange: () ->
                new_val = parseFloat($("#"+coeff+"-slider").val())
                box.val(new_val)
        })

        trig = () ->
            box.trigger('change')

        # slider.on('mouseup', box.trigger('change'))
        $('#irs-'+@IRS_COUNTER).on('mouseup', trig )

        # TODO: this should only link slider-> box??? since onModelChange.trigger on box val change
        # add listeners to link the box and the slider
        # from slider to box (added as onChange callback)
        # from box to slider
        box.change( () ->
#            new_val = parseFloat($("#"+coeff+"-box").val())
#            slider = $("#"+coeff+"-slider")
#            slider.ionRangeSlider("update", {
#                min: new_val-10,
#                max: new_val+10,
#                from: new_val
#                }
#            )

            # add onModelChange trigger to box
            model_builder.submit_node()
            $(document).trigger("selectNodeChange")
        )


    get_selected_node_type: () ->
        ###
        returns a string indicating the type (context, personality, or state) of the selected node
        ###
        n_parents = @_model.get_parents_of(@selected_node).length
        if n_parents <= 0  # source node
            if @get_node_model(@selected_node) == 'context-var-options'
                return 'context-var-options'
            else if @get_node_model(@selected_node) == 'personality-var-options'
                return 'personality-var-options'
            else
                return 'unknown-source'
        else  # state node
            return 'state'

    _add_modeling_options: (target_obj, selector_string) ->
        # adds attributes retrieved using selector_string to target_object
        # then returns object with values set
        model_options = $(selector_string)
        # console.log('adding options:', model_options)
        for option in model_options
            # console.log(option.name,':',option.value)
            target_obj[option.name] = parseFloat(option.value)
        return target_obj

    set_node_assumption: (node_id, assumption) ->
        ###
        sets the node assumption 
        ###
        node = @get_node(node_id)
        node.assumption = assumption

    get_node_assumption_input: (node_id, assumption) ->  # TODO: this is duplicate of modeling_options_controls.update_node_assumption ?
        ###
        gets the node assumption input from the UI
        ###
        node = @get_node(node_id)
        switch node.type
            when 'personality-var-options'
                assumption = {calculator: simulator.calculator_constant, arguments: {value: simulator.get_personality_value(node_id)}}
            when 'context-var-options'
                switch $('#calculator-preset').val()
                    when 'random_walk'
                        assumption = {
                            calculator: simulator.calculator_random_walk,
                            arguments: {
                                scale: $('#scale-box').val(),
                                initial_value: 5  # TODO: add init val box
                            }
                        }
                    when 'constant'
                        assumption = {
                            calculator: simulator.calculator_constant,
                            arguments: {value: $('#value-box').val()}
                        }
                    when 'step'
                        assumption = {
                            calculator: simulator.calculator_step,
                            arguments: {
                                step_time: $('#step_time-box').val(),
                                low: $('#low-box').val(),
                                high: $('#high-box').val()
                            }
                        }
                    when 'square'
                        assumption = {
                            calculator: simulator.calculator_square,
                            arguments: {
                                dt: $('#dt-box').val(),
                                low: $('#low-box').val(),
                                high: $('#high-box').val()
                            }
                        }
                    when 'upload'
                        assumption = {
                            calculator: simulator.calculator_linear_interpolate,
                            arguments: {
                                times:  [0,1,2,3,4,5,6 ,7 ,8 ,9 ,10, 11],  # TODO: get these values from the uploaded file
                                values: [1,1,2,3,5,8,13,21,34,55,89,144],
                                before: 0,  # TODO: set these values more intelligently
                                after: 0
                            }
                        }
                    else
                        assumption = undefined
                        console.log("WARN: node type not recognized, '"+node.type+"' assumption undefined.")
                        throw Error('bad node type')
        return assumption
        
    model_is_complete: () ->
        # returns true if all nodes in model are specified
        for nodeID of @_model.nodes
            if not @node_is_complete(@get_node(nodeID))
                return false
        # else all nodes are specified
        if @_model.node_count <= 0
            return false  # empty graphs don't count
        else
            return true


try
    window.ModelBuilder = ModelBuilder
catch error
    module.exports = ModelBuilder