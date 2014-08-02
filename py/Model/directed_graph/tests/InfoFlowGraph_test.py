from py.Model.InfoFlow.InfoFlowGraph import InfoFlowGraph

__author__ = 'tylarmurray'

import unittest


class infoFlowGraph_tester(unittest.TestCase):

    def test_inheritance(self):
        # this is mainly just me figuring out how this works, not an actually good test.
        dsl = ur'ctx2 -> constr2\n constr2 -> constr3'
        dg = InfoFlowGraph(DSL=dsl)
        dg._nodes

    def test_specify_nodes(self):
        dsl = ur'ctx2 -> constr2\n constr2 -> constr3'
        dg = InfoFlowGraph(DSL=dsl)
        nodes = ['ctx2', 'constr2', 'constr3']

        for i in range(len(nodes)):
            nextNode = dg.getNextNodeToSpec()
            self.assertIn(nextNode.name, nodes)
            dg.getNode(nextNode.name).defined = True

        self.assertIsNone(dg.getNextNodeToSpec())

