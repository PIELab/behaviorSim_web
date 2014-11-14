class Simulator
    ###
    class for maintaining basic simulations
    ###
    constructor: (model, time_length=100, time_step=1) ->
        ###
        time_step: length of time between samples in minutes
        ###
        @_model = model
        @_time_length = time_length
        @_time_step = time_step

        # set up integration calculator
        @fluid_flow = Integrator(@ODE_fluid_flow)
        @step = .25

    recalc: (node_id) ->
        ###
        ensures that the last calculations for the node are thrown out and new calculations are done.
        :returns: true if recalc is set, false if no data values exist anyway
        ###
        # clear out data_values so that get_values recalcs next time
        console.log('clearing data for node:', node_id)
        node = @_model.get_node(node_id)
        if node.data_values
            delete node.data_values

            # must recalc all children too...
            for childId in node.children
                @recalc(childId)
            return true
        else
            return false

    set_model: (new_model) ->
        # @_model = new_model_obj   # doesn't work here b/c of js "copy of a reference" behaviour
        #   causes reference of global model to be unaltered... we want to modify that (so model_builder can see new model)
        # Clear all the 'old' properties from the object
        for prop in @_model
            delete @_model[prop]
        # Insert the new ones
        $.extend(@_model, new_model)   

    # ===============================================================================
    #                                 calculators
    #                     (TODO: prev_value should be included in args)
    # ===============================================================================
        
    calculator_random_walk: (t, prev_value, args) ->
        if args.scale
            return prev_value + Math.random()*args.scale - args.scale/2
        else
            throw Error('cannot run random walk without scale!')
            
    calculator_linear_interpolate: (t, prev_value, args, chill=true) ->
        # linearly interpolates value from a set of time & value pairs in args
        # :param args.times: array of times constrained by assumptions below
        # :param args.values: array of values corresponding to time values
        # :param chill: throws errors when accessing outside array if true, else uses before & after (see below)
        # :param args.before: value to return when t < earliest_sample_time
        # :param args.after: value to reutn when t > latest_sample_time
        #
        # assumes:
        # * args.times and args.values are arrays with matching indicies 
        # * time is ordered sequentially (eg: [0,1,2], [1.5,2.5,3.5], or  [3,4,5,7,19])
        # * time values are positive
        # * time values are spaced by at least 1.0 units (NOT [0.1,0.2,0,3] or [1,2,2.5,3])
        if t < args.times[0]
            if chill
                return args.before
            else
                throw Error('cannot get time before earliest sample')
        else if t > args.times[args.times.length-1]
            if chill
                return args.after
            else 
                throw Error('cannot get time after latest sample')
        else # we are in between samples
            # find samples which are closest (assuming ordered time list)
            i = 0
            while args.times[i] < t
                i += 1
                if args.times[i] == t  # if exact time sample found
                    return args.values[i]
            
            m = (args.values[i] - args.values[i-1]) / (args.times[i] - args.times[i-1])
            b = args.values[i-1]
            x = t - args.times[i-1]
            return m*x + b
            
    calculator_step: (t, prev_value, args) ->
        if args.step_time and args.low and args.high
            if t < args.step_time
                return args.low
            else
                return args.high
        else 
            throw Error('step function parameters missing!')
            
    calculator_square: (t, prev_value, args) ->
        if args.dt != undefined and args.low != undefined and args.high != undefined
            #start low
            if t%(2*args.dt) < args.dt
                return args.low
            else 
                return args.high
        else
            throw Error('square wave function parameters missing!') 

    calculator_constant: (t, prev_value, args) ->
        if args.value != undefined
            return +args.value
        else
            throw Error('value not specified for constant calculator!')
            
    calculator_linear_combination: (t, prev_value, prev_dt, args) ->
        value = 0
        for parent in args.parents
            value += simulator.get_node_values(parent)[t] * args['c_'+parent]
        return value

    ODE_fluid_flow: (t, y) =>
        val = 0

        for parent in @args.parents
            theta = parseFloat(@args['theta_'+parent])  # theta = time delay
            C = parseFloat(@args['c_'+parent])  # C = regression weight
            if not theta? or not C?
                throw Error('missing parent parameter for fluid flow calculator')
            if t-theta <= 0  # use 1st value as steady state before(TODO: improve this)
                parent_v = @get_node_values(parent)[0]
            else if t-theta >= @_time_length  # use last value as steady state after (TODO: improve this)
                parent_v = @get_node_values(parent)[@_time_length-1]
            else # t is within bounds
                parent_v = @get_node_values(parent)[t - theta]

            val += C * parent_v
            if isNaN(val)
                console.log('ERR INFO:: theta:',theta,'C:',C,'p:',parent_v )

        val = (val - y) / parseFloat(@args.tao)
        if isNaN(val)
            console.log('ERR INFO:: y:',y,'tao:',@args.tao )
        return val
        
    calculator_differential_equation: (t, prev_value, prev_dt, args) =>
        # requires Integrator from /js/Integrator
        # formulation from p2 of http://csel.asu.edu/downloads/Publications/AdaptivePrevention/2012ACC_Dong_etal_preprint.pdf
        if args.parents? and args.tao? and prev_value? and prev_dt?
            @args = args  # bind arguments to object for temporary storage (rather than passing to the integrator)
            return @fluid_flow.euler(prev_value, t, @step);
        else
            console.log('args given:','t:',t,'prev_value:',prev_value,'prev_dt:',prev_dt,'args:',args)
            throw Error('missing parameter for differential-equation calculator')
        
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
        prev_dt = formulation.initial_ddt ? 0
        t = 0
        if !formulation.calculator  # if calculator not defined explicitly in formulation
            throw Error('calculator not defined for node!')
        
        formulation.parents = parents
        
        while t < @_time_length
            new_value = formulation.calculator(t, prev_value, prev_dt, formulation)
            data.push(new_value)
            prev_dt = new_value - prev_value
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
                return @calculate_from_formulation(node.formulation, node.parents, node)

            else if node.assumption != undefined  # if node assumption has been set for context/personality nodes
                return @calculate_from_assumption(node.assumption, node)

            else
                window.myNode = node
                console.log('node in error:', node)
                throw Error('formulation or assumption not set for node')

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
            val =  @_model.get_node(node_id).formulation[parameter_name]
            if val?
                return val
            else
                throw Error('bad val')
        catch err
            if use_default
                return @_get_default_value()
            else
                throw err

    _get_default_value: () ->   # TODO: improve default value getter
        max = 10
        min = 0
        return Math.floor(Math.random() * (max - min) + min)

try
    window.Simulator = Simulator
catch error
    module.exports = Simulator