class ModelBuilder
    ###
    A generalized system model specification object for building a model JSON object.

    Properties:
    - nodeSize: total number of nodes.
    - edgeSize: total number of edges.
    ###
    constructor: () ->
        @_model = new Model
        @selected_node = 'Verbal_Persuasion'
        @completed_nodes = []

    complete_a_node: (node_id) ->
        if node_id in @completed_nodes  # if node already in list
            return undefined
        else
            @completed_nodes.push(node_id)
            $('#completed-node-list').html(model_builder.completed_nodes)
            return @completed_nodes

        model_changed_event.trigger()

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
        @set_node_assumption(nname)
        simulator.recalc(nname)
        return node

    add_node: (nname=@get_node_name(), type=@get_selected_node_type(), parents=@get_node_parents(), children=@get_node_children(), formulation=@get_node_formulation()) ->
        ###
        adds a node to the model
        ###
        @complete_a_node(@selected_node)
        return @_model.update_node(nname, type, parents, children, formulation)

    get_node_name: () ->
        return @selected_node

    get_node_parents: () ->
        return @_model.get_node(@selected_node).parents ? []

    get_node_children: () ->
        return @_model.get_node(@selected_node).children ? []

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
                mu : $("input[name='mu']").val()
                sigma: $("input[name='sigma']").val()
            }
        else if node_type == 'linear-combination'
            return @_add_modeling_options({type:"linear-combination"}, '.model-option-linear')
        else if node_type == 'fluid-flow'
            return @_add_modeling_options({type:"fluid-flow"}, '.model-option-fluid-flow')
        else if node_type == 'other'
            return {
                type : "general_formulation"
                formula: $("input[name='"+@selected_node+"_func']").val()
            }
        else
            throw Error('unknown node formulation req: '+node_type)

    set_selected_node: (node_id) ->
        model_builder.selected_node = node_id
        node_selection_changed.trigger()

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
        for node in @_model.nodes
            if node.formulation
                @completed_nodes.push(node.name)
                
        # select the first node of the new model
        @selected_node = @_model.nodes[0].name

        # update the dsl display
        $('#textarea').val(@get_model_dsl())
        
        console.log('model set to:', @_model)
        model_changed_event.trigger()

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
        for line in dsl_str.split('\n')
            line = line.split('//')[0]  # this ignores everything after a // (comments)
            if line == '' # ignore blank lines
                continue
            try
                stmt = line.split('->')  # split by arrow
                n1 = stmt[0].trim()
                n2 = stmt[1].trim()
                # console.log(n1, '->', n2)
                @_model.add_node(n1)
                @_model.add_node(n2)
                @_model.add_edge(n1, n2);
            catch error  # malformed line (no big deal)
                console.log('dsl parse error @: ', line)

    get_selected_node_functional_form: () ->
        ###
        returns a string showing the functional form of the selected node
        ###
        lhs = @selected_node + "("  # left hand side
        rhs = ""  # right hand side

        switch @get_node_model(@selected_node)
            when 'linear-combination'
                for parent in @_model.get_node(@selected_node).parents
                    lhs += parent + ', '
                    rhs += 'c_'+parent+'*'+parent+'(t) +'
                lhs += 't)'
                rhs = rhs[0..rhs.length-2]  # trim off last plus
            when 'fluid-flow'
                rhs += 'tao_' + @selected_node + '*d' + @selected_node + '/dt =' + @selected_node
                for parent in @_model.get_node(@selected_node).parents
                    rhs += '+ c_' + parent + '*' + parent + '(t - theta_' + parent + ')'
                lhs += 't)'
            when 'other'
                for parent in @_model.get_node(@selected_node).parents
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

        return lhs + ' = ' + rhs

    get_selected_node_form: () ->
        ###
        returns an html string for the contents of a form used to specify the selected node
        ###
        _result = ''
        switch @get_node_model(@selected_node)
            when 'linear-combination'
                for parent in @_model.get_node(@selected_node).parents
                    _result += 'c_' + parent + ' = <input type="text" name="c_' + parent + '" class="model-option-linear"><br>'
            when 'fluid-flow'
                _result += 'tao_' + @selected_node + ' = <input type="text" name="tao_'
                _result += @selected_node + '" class="model-option-fluid-flow"> <br>'
                for parent in @_model.get_node(@selected_node).parents
                    _result += 'c_'+parent+' = <input type="text" '+'name="c_'
                    _result += @selected_node+'_'+parent+'" class="model-option-fluid-flow"><br>theta_'+parent
                    _result += ' = <input type="text" name="theta_'+@selected_node+'_'+parent
                    _result += '" class="model-option-fluid-flow"><br>'
            when 'other'
                _result += 'define your function in javascript<br>'
                _result += '<input type="textarea" name="'+@selected_node
                _result += '_func" style="width:100%" rows="17"></input>'
            when 'context-var-options'
                _result += 'Enter a comma-separated list of environmental influences. <input type="textarea" name="dep-list" class="model-option-context">'
            when 'personality-var-options'
                _result += 'Assuming a normal distribution across the population,<br> mu = <input type="text" name="mu" class="model-option-personality"><br>sigma = <input type="text" name="sigma" class="model-option-personality">'
            else
                throw Error('unknown node form "'+@get_node_model(@selected_node)+'"')
        return _result

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
        model_options = $(selector_string)
        console.log('adding options '+model_options)
        for option in model_options
            console.log(option.name+':'+option.value)
            target_obj[option.name] = option.value
        return target_obj

    set_node_assumption: (node_id, assumption) ->
        ###
        sets the node assumption, if unidentified default for node type is used
        ###
        node = @_model.get_node(node_id)
        if assumption
            node.assumption = assumption
        else
        switch node.type
            when 'personality-var-options'
                node.assumption = {calculator: simulator.calculator_constant, arguments: {value: simulator.get_personality_value(node_id)}}
            when 'context-var-options'
                node.assumption = {calculator: simulator.calculator_random_walk, arguments: {scale: 10, initial_value:5}}
            else
                console.log("WARN: node type not recognized, '"+node.type+"' assumption not set.")

try
    window.ModelBuilder = ModelBuilder
catch error
    module.exports = ModelBuilder