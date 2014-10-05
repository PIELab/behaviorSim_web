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
    constructor: ->
        @_model = new Model

    submit_node: () ->
        ###
        accepts submission of node & updates or adds node spec if needed
        ###
        nname = @get_node_name()
        for existing_node in @_model.nodes
            if nname == existing_node.name
                console.log('updating existing node')
                # TODO
                return
        # else
        console.log('adding node to the model')
        return @add_node()

    add_node: () ->
        ###
        adds a node to the model
        ###
        @_model.add_node(@get_node_name(),
            @get_node_type(),
            @get_node_parents(),
            @get_node_children(),
            @get_node_formulation())

        complete_a_node(graph.selected_node)

    get_node_name: () ->
        return graph.selected_node

    get_node_type: () ->
        inflows = getInputsOf(graph.selected_node);
        if inflows.length > 0
            return 'state'
        else
            return graph.selected_node_model

    get_node_parents: () ->
        _result = []
        for parent of graph.getNode(graph.selected_node)._inEdges
            _result.push(parent)
        return _result

    get_node_children: () ->
        _result = []
        for parent of graph.getNode(graph.selected_node)._outEdges
            _result.push(parent)
        return _result

    get_node_formulation: () ->
        node_type = graph.selected_node_model
        if node_type == 'context-var-options'
            return {
                type : "dependency_list"
                dependencies : @get_context_node_dependencies()
            }
        else if node_type == 'personality'
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
                formula: $("input[name='"+graph.selected_node+"_func']").val()
            }
        else
            console.log('ERR: unknown node formulation req: '+node_type)

    _add_modeling_options: (target_obj, selector_string) ->
        model_options = $(selector_string)
        console.log('adding options '+model_options)
        for option in model_options
            console.log(option.name+':'+option.value)
            target_obj[option.name] = option.value
        return target_obj

    get_context_node_dependencies: () ->
        return $("input[name='dep-list']").val()

window.model_builder = new ModelBuilder()
