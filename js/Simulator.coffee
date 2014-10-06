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

    calculator_random_walk: (t, prev_value, args) ->
        if args.scale
            return prev_value + Math.random()*args.scale - args.scale/2
        else
            throw Error('cannot run random walk without scale!')

    calculate_from_assumption: (assumption) ->
        # calculates a set of values using given assumption
        data = []
        prev_value = assumption.initial_value ? 0
        t = 0
        while t < @_time_length
            console.log('computing '+assumption.calculator+'('+t+') using prev_value and args')
            new_value = assumption.calculator(t, prev_value, assumption.arguments)
            data.push(new_value)
            prev_value = new_value
            t += 1
        return data

    get_node_values: (node_id) ->
        node = @get_node_object(node_id)
        if node.data_values
            return node.data_values
        else
            if node.type == 'state'
                # calculate from formulation & parents (if possible)
                calc_type = node.formulation
                throw Error('state calc not yet implemented')
            # if node assumption has been set
            else if node.assumption
                return @calculate_from_assumption(node.assumption)
            else
                # set default assumption
                @set_node_assumption(node_id, @calculator_random_walk,{scale: 10, initial_value:5})
                return @calculate_from_assumption(node.assumption)

    set_node_assumption: (node_id, calculator, args) ->
        @get_node_object(node_id).assumption = {calculator:calculator, arguments:args}

    get_node_object: (node_id) ->
        for node in @_model.nodes
            if node.name == node_id
                return node
        # else
        throw Error('node not found! : '+node_id)
try
    window.Simulator = Simulator
catch error
    module.exports = Simulator