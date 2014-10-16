class Model
    ###
    A data class for holding a JSON model object.

    example object:
    ```js
    {
        "creator": "John1234",
        "name": "super_duper_cool_model",
        "description": "This model uses the super duper cool theory with constants I made up!",
        "time_step": 1,
        "node_count": 2,
        "nodes":[
            {
                "name":"node1",
                "type": "context",
                "parents": [],
                "children": [
                    "node2"
                ],
                "formulation":{
                    "type": "constant",
                    "value":0.45
                }
            },{
                "name":"node2",
                "type": "context",
                "parents": [
                    "node1"
                ],
                "children": [],
                "formulation":{
                    "type": "linear sum",
                    "coeff_node1" : 0.45
                }
            }
        ]
    }
    ```
    ###
    constructor: ->
        @creator = ''
        @name = ''
        @description = ''
        @nodes = []
        @node_count = 0
        @time_step = 1

    add_node: (name, type=undefined, parents=[], children=[], formulation=undefined) ->
        ###
        adds a node to the model. returns node if added, undefined if node already exists.
        ###
        if @get_node(name) == undefined
            new_node = {
                "name":name,
                "type": type,
                "parents": parents,
                "children": children,
                "formulation":formulation}
            @nodes.push(new_node)
            @node_count += 1
            return new_node
        else
            return undefined

    add_edge: (from_node, to_node) ->
        fn = @get_node(from_node)
        tn = @get_node(to_node)
        if to_node not in fn.children
            fn.children.push(to_node)
        if from_node not in tn.parents
            tn.parents.push(from_node)

    get_parents_of: (node_id) ->
        ###
        _Returns:_ list of parents of given node or empty array if None
        ###
        return @get_node(node_id).parents

    get_node: (id) ->
        ###
        _Returns:_ the node object.
        ###
        for node in @nodes
            if node.name == id
                return node
        return undefined

try
    window.Model = Model
catch error
    module.exports = Model
