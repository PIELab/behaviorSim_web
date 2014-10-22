class Model extends Graph
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
        @time_step = 1
        super()

    add_node: (name, type=undefined, parents=[], children=[], formulation=undefined) ->
        ### !!! Overrides Graph.add_node ###
        return super(name, parents, children, {name:name, type:type, formulation:formulation})

    update_node: (name, type, parents, children, formulation, assumption) ->
        ###
        !!! Overrides Graph.add_node
        updates the given node. undefined should be passed for any items that should remain unchanged
          Example usage: @update_node('my_node_name', undefined, ['node_b', 'node_c'], undefined, undefined)
          updates only the parents of the 'my_node_name' node.
        If node is not found, it is added.
        ###
        node = @get_node(name)
        if node
            node.type = type ? node.type
            node.parents = parents ? node.parents
            node.children = children ? node.children
            node.formulation = formulation ? node.formulation
            node.assumption = assumption ? node.assumption
        else
            # add node
            @add_node(name, type, parents ? [], children ? [], formulation)

try
    window.Model = Model
catch error
    module.exports = Model
