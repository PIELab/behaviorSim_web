from py.Model.InfoFlow.InfoFlowGraph import InfoFlowGraph

__author__ = 'tylarmurray'

import unittest


class infoFlowGraph_tester(unittest.TestCase):

    def test_inheritance(self):
        # this is mainly just me figuring out how this works, not an actually good test.
        dsl = '''ctx2 -> constr2
                 constr2 -> constr3'''
        dg = InfoFlowGraph(DSL=dsl)
        dg._nodes

    def test_specify_nodes(self):
        dsl = '''ctx2 -> constr2
                constr2 -> constr3'''
        dg = InfoFlowGraph(DSL=dsl)
        nodes = ['ctx2', 'constr2', 'constr3']

        # check for each node
        for i in range(len(nodes)):
            next_node = dg.getNextNodeToSpec()
            self.assertIn(next_node.name, nodes)
            dg.getNode(next_node.name).defined = True
            nodes.remove(next_node.name)

        # no nodes left, should get none now
        self.assertIsNone(dg.getNextNodeToSpec())

    def test_specify_nodes_bigger_graph(self):
        """
        same as test_specify_nodes, but uses a bigger graph which I manually observed to fail.
        """
        dsl = '''a -> b
                b -> c
                c -> d
                b2 -> c
                c2 -> d
                b2 -> c2
                c2 -> e
                d -> e'''
        dg = InfoFlowGraph(DSL=dsl)
        nodes = ['a', 'b', 'c', 'd', 'e', 'b2', 'c2']

        # check for each node
        for i in range(len(nodes)):
            next_node = dg.getNextNodeToSpec()
            self.assertIn(next_node.name, nodes)
            dg.getNode(next_node.name).defined = True
            nodes.remove(next_node.name)

        # no nodes left, should get none now
        self.assertIsNone(dg.getNextNodeToSpec())