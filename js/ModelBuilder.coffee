class ModelBuilder
    ###
    A generalized system model specification object for building a model JSON object.

    ## Overview example:

    ```js
    var bulider = new ModelBuilder;
    builder.spec_node(); //  specifies a node using default get_node_type, get_node_spec, etc

    // overloads the get_node_type function to fit your application
    builder.get_node_type = function(){
        return $('#node-type-selector').value()
    }

    builder.spec_node();  // specifies a node using new get_node_type
    ```

    ## Properties:
    - nodeSize: total number of nodes.
    - edgeSize: total number of edges.
    ###
    constructor: () ->
        @_model = new Model
        @_graph = new Graph;
        @selected_node = 'Verbal_Persuasion'
        @completed_nodes = []
        @selected_node_model = 'context-var-options'
        
    submit_node: (nname=@get_node_name(), type=@get_node_type(), parents=@get_node_parents(), children=@get_node_children(), formulation=@get_node_formulation()) ->
        ###
        accepts submission of node & updates or adds node spec if needed
        ###
        for existing_node in @_model.nodes
            if nname == existing_node.name
                console.log('updating existing node')
                # TODO
                return
        # else
        console.log('adding node to the model')
        return @add_node(nname, type, parents, children, formulation)

    add_node: (nname=@get_node_name(), type=@get_node_type(), parents=@get_node_parents(), children=@get_node_children(), formulation=@get_node_formulation()) ->
        ###
        adds a node to the model
        ###
        @_model.add_node(nname, type, parents, children, formulation)

        complete_a_node(@selected_node)

    get_node_name: () ->
        return @selected_node

    get_node_type: () ->
        inflows = getInputsOf(@selected_node);
        if inflows.length > 0
            return 'state'
        else
            return @selected_node_model

    get_node_parents: () ->
        _result = []
        for parent of @_graph.getNode(@selected_node)._inEdges
            _result.push(parent)
        return _result

    get_node_children: () ->
        _result = []
        for parent of @_graph.getNode(@selected_node)._outEdges
            _result.push(parent)
        return _result

    get_node_formulation: () ->
        node_type = @selected_node_model
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

    load_model_from_file: (model_file) ->
        ###
        loads a the given file and overwrites the current model
        ###
        new_model = new Model
        throw ReferenceError('load_model_from_file() not yet implemented')

    set_model: (new_model_obj) ->
        ###
        sets the model to the given object
        ###
        @_model = new_model_obj
        console.log('model set to:')
        console.log(@_model)

    load_model: (file_loc) ->
        ###
        loads a model from a given json file location (presumably on server)
        ###
        $.ajax file_loc,
            success  : (data, status, xhr) =>
                @set_model(data)
                $('#textarea').val(@get_model_dsl())
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
                @_graph.addNode(n1)
                @_graph.addNode(n2)
                @_graph.addEdge(n1, n2);
            catch error  # malformed line (no big deal)
                console.log('dsl parse error @: ' + line)

    get_selected_node_form: () ->
        _result = ''
        switch @selected_node_model
            when 'linear-combination'
                for parent of @_graph.getNode(@selected_node)._inEdges
                    _result += 'c_' + parent + ' = <input type="text" name="c_' + parent + '" class="model-option-linear"><br>'
            when 'fluid-flow'
                _result += 'tao_' + @selected_node + ' = <input type="text" name="tao_'
                _result += @selected_node + '" class="model-option-fluid-flow"> <br>'
                for parent of @_graph.getNode(@selected_node)._inEdges
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
                throw Error('unknown node form "'+@selected_node_model+'"')
        return _result

    _add_modeling_options: (target_obj, selector_string) ->
        model_options = $(selector_string)
        console.log('adding options '+model_options)
        for option in model_options
            console.log(option.name+':'+option.value)
            target_obj[option.name] = option.value
        return target_obj

try
    window.model_builder = new ModelBuilder
catch error
    module.exports = ModelBuilder