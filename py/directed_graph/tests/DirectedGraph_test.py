__author__ = 'tylar'

''' unit test for DirectedGraph '''
import unittest

from py.directed_graph.DirectedGraph import DirectedGraph

class basic_leveling_check(unittest.TestCase):

    def test_DSL_init(self):
        dsl = ur'ctx2 -> constr2\n constr2 -> constr3'
        dg = DirectedGraph(DSL=dsl)
        self.assertTrue(dg.hasNode('ctx2'))
        self.assertTrue(dg.hasNode('constr2'))
        self.assertTrue(dg.hasNode('constr3'))

    def test_malformed_line_yields_warning(self):
        dsl = ur'ctx2 -> constr2\n constr2 -> constr3\n notWholeLineHere'
        self.assertRaises(Warning, DirectedGraph, DSL=dsl)

    def test_specify_nodes(self):
        dsl = ur'ctx2 -> constr2\n constr2 -> constr3'
        dg = DirectedGraph(DSL=dsl)
        nodes = ['ctx2', 'constr2', 'constr3']

        for i in range(len(nodes)):
            nextNode = dg.getNextNodeToSpec()
            self.assertIn(nextNode, nodes)
            dg.getNode(nextNode).defined = True

        self.assertIsNone(dg.getNextNodeToSpec())