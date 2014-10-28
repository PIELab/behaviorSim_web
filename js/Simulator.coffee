class Simulator
    ###
    class for maintaining basic simulations
    ###
    constructor: (model, time_length=20, time_step=1) ->
        ###
        time_step: length of time between samples in minutes
        ###
        @_model = model
        @_time_length = time_length
        @_time_step = time_step

    recalc: (node_id) ->
        ###
        ensures that the last calculations for the node are thrown out and new calculations are done.
        ###
        # clear out data_values so that get_values recalcs next time
        @_model.get_node(node_id).data_values = undefined
        
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
            return +args.value
        else
            throw Error('value not specified for constant calculator!')
            
    calculator_linear_combination: (t, prev_value, args) ->
        value = 0
        for parent in args.parents
            value += simulator.get_node_values(parent)[t] * args['c_'+parent]
        return value

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
        
    calculate_from_formulation: (formulation, parents, node=undefined) ->
        ### 
        calculates a set of values using given formulation
        :param node: node object to save the data for later
        ###
        data = []
        prev_value = formulation.initial_value ? 0  # TODO: see issue #36
        t = 0
        if !formulation.calculator  # if calculator not defined explicitly in formulation
            #set calculator using formulation.type name
            if formulation.type == "linear-combination"
                formulation.calculator = @calculator_linear_combination
            else
                throw Error("calculator not defined for formulation", formulation)
        
        formulation.parents = parents
        
        while t < @_time_length
            new_value = formulation.calculator(t, prev_value, formulation)
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
        node = @_model.get_node(node_id)
        if node.data_values && !recalculate
            return node.data_values
        else
            if node.type == 'state'
                # calculate from formulation & parents (if possible)
                calc_type = node.formulation
                return @calculate_from_formulation(node.formulation, node.parents, node)
            # if node assumption has been set
            else if node.assumption
                return @calculate_from_assumption(node.assumption, node)
            else
                console.log('formulation or assumption not set')
                return []

    get_personality_value: (node_id) ->
        ###
        returns a value selected from the given personality node's probability distribution
        ###
        return normal_random(@get_node_spec_parameter(node_id, 'mu'), @get_node_spec_parameter(node_id, 'sigma'))
        
    get_node_spec_parameter: (node_id, parameter_name, use_default=false) ->
        ###
        returns the value of the requested parameter for the given node
        ###
        try
            return @_model.get_node(node_id).formulation[parameter_name]
        catch err
            if use_default
                return @_get_default_value()
            else
                throw err

    _get_default_value: () ->
        return 1  # TODO: improve default value getter
try
    window.Simulator = Simulator
catch error
    module.exports = Simulator