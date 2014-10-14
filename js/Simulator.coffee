class Simulator
    ###
    class for maintaining basic simulations
    ###
    constructor: (model, graph, time_length=20, time_step=1) ->
        ###
        time_step: length of time between samples in minutes
        ###
        @_model = model
        @_graph = graph
        @_time_length = time_length
        @_time_step = time_step
        
    set_model: (new_model) ->
        # @_model = new_model_obj   # doesn't work here b/c of js "copy of a reference" behaviour
        #   causes reference of global model to be unaltered... we want to modify that (so model_builder can see new model)
        # Clear all the 'old' properties from the object
        for prop in @_model
            delete @_model[prop]
        # Insert the new ones
        $.extend(@_model, new_model)    
        
    calculator_random_walk: (t, prev_value, args) ->
        if args.scale
            return prev_value + Math.random()*args.scale - args.scale/2
        else
            throw Error('cannot run random walk without scale!')

    calculator_constant: (t, prev_value, args) ->
        if args.value
            return args.value
        else
            throw Error('value not specified for constant calculator!')

    calculate_from_assumption: (assumption, node=undefined) ->
        ### 
        calculates a set of values using given assumption
        :param node: node object to save the data for later
        ###
        data = []
        prev_value = assumption.initial_value ? 0
        t = 0
        while t < @_time_length
            new_value = assumption.calculator(t, prev_value, assumption.arguments)
            data.push(new_value)
            prev_value = new_value
            t += 1
        if node  # save values if node given
            node.data_values = data
        return data

    get_node_values: (node_id, recalculate=false) ->
        ###
        returns values for given node
        :param recalculate: forces recalculation even if existing values already saved
        ###
        node = @get_node_object(node_id)
        if node.data_values && !recalculate
            return node.data_values
        else
            if node.type == 'state'
                # calculate from formulation & parents (if possible)
                calc_type = node.formulation
                throw Error('state calc not yet implemented')
            # if node assumption has been set
            else if node.assumption
                return @calculate_from_assumption(node.assumption, node)
            else
                # set default assumption
                if node.type == 'personality-var-options'
                    @set_node_assumption(node_id, @calculator_constant, {value:@get_personality_value(node_id)})
                else
                    @set_node_assumption(node_id, @calculator_random_walk,{scale: 10, initial_value:5})
                return @calculate_from_assumption(node.assumption, node)

    set_node_assumption: (node_id, calculator, args) ->
        @get_node_object(node_id).assumption = {calculator:calculator, arguments:args}

    get_personality_value: (node_id) ->
        ###
        returns a value selected from the given personality node's probability distribution
        ###
        return normal_random(@get_node_spec_parameter(node_id, 'mu'), @get_node_spec_parameter(node_id, 'sigma'))

    get_node_object: (node_id) ->
        for node in @_model.nodes
            if node.name == node_id
                return node
        # else
        throw Error('node not found! : '+node_id)
        
    get_node_spec_parameter: (node_id, parameter_name) ->
        ###
        returns the value of the requested parameter for the given node
        ###
        return @get_node_object(node_id).formulation[parameter_name]
try
    window.Simulator = Simulator
catch error
    module.exports = Simulator