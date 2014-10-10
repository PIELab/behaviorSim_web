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
    add_node: (name, type, parents, children, formulation) ->
        @nodes.push({
            "name":name,
            "type": type,
            "parents": parents,
            "children": children,
            "formulation":formulation})
        @node_count += 1

try
    window.Model = Model
catch error
    module.exports = Model
