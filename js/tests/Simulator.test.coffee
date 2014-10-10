Simulator = require '../Simulator'
Graph = require '../Graph'

exports.SimulatorTest =

    'test default assumptions yield data': (test) ->
        model = {
                "creator": "John1234",
                "name": "super_duper_cool_model",
                "description": "This model uses the super duper cool theory with constants I made up!",
                "time_step": 1,
                "node_count": 2,
                "nodes":[
                    {
                        "name":"test_node",
                        "type": "context",
                        "parents": []
                        "children": [
                            "node2"
                        ]
                    }
                ]
            }

        graph = new Graph
        graph.addNode('test_node')

        simulator = new Simulator(model, graph)
        result = simulator.get_node_values('test_node')
        test.ok(result)
        test.done()

    'test default assumption data is expected length': (test) ->
        model = {
                "creator": "John1234",
                "name": "super_duper_cool_model",
                "description": "This model uses the super duper cool theory with constants I made up!",
                "time_step": 1,
                "node_count": 2,
                "nodes":[
                    {
                        "name":"test_node",
                        "type": "context",
                        "parents": []
                        "children": [
                            "node2"
                        ]
                    }
                ]
            }

        graph = new Graph
        model_builder._graph.addNode('test_node')

        simulator = new Simulator(model, graph)
        result = simulator.get_node_values('test_node')
        test.equal(result.length, simulator._time_length)
        test.done()