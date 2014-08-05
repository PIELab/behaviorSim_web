__author__ = 'tylar'

""" unit test for DirectedGraph """
import unittest

from py.Model.directed_graph.DirectedGraph import DirectedGraph

class DG_tester(unittest.TestCase):

    def test_DSL_init(self):
        dsl = '''ctx2 -> constr2
                constr2 -> constr3'''
        dg = DirectedGraph(DSL=dsl)
        self.assertTrue(dg.hasNode('ctx2'))
        self.assertTrue(dg.hasNode('constr2'))
        self.assertTrue(dg.hasNode('constr3'))

    def test_malformed_line_yields_warning(self):
        dsl = '''ctx2 -> constr2
        constr2 -> constr3
        notWholeLineHere'''
        self.assertRaises(Warning, DirectedGraph, DSL=dsl)

    def test_get_node(self):
        dsl = '''ctx2 -> constr2
        constr2 -> constr3'''
        dg = DirectedGraph(DSL=dsl)

        self.assertIsNotNone(dg.getNode('ctx2'))
        self.assertIsNotNone(dg.getNode('constr2'))
        self.assertIsNotNone(dg.getNode('constr3'))
        self.assertIsNone(dg.getNode('this_is_not_a_real_node_name'))
