__author__ = '7yl4r'


""" unit test for the model builder """
import unittest

from py.ModelBuilder import ModelBuilder
from py.Model.Model import Model

class model_builder_tester(unittest.TestCase):
    def test_use_unset_model_error(self):
        mb = ModelBuilder()
        self.assertRaises(Exception, mb.getNextNode)

    def test_build_a_model(self):
        # setup
        mod = Model()
        mb = ModelBuilder(mod)

        # === "draw" ===
        infoFlow = ur'ctx2 -> constr2\n ctx2 -> constr3\n constr2 -> constr3\n pers1 -> constr2\n pers2 -> constr3'
        mb.updateDSL(infoFlow, DSL_type='info-flow', model=mod)

        # === "specify" source vertices ===
        # context vars
        mb.specifyContextNode('TODO: how to compute from env vars here.', node_name='ctx2')

        # constant personality var
        mb.specifyPersonalityNode('constant .934', node_name='pers1')

        # stochastic personality var
        mb.specifyPersonalityNode('normal mu=4 sigma=1', node_name='pers2')

        # === "specify" construct vertex equations ===
        mb.specifyConstructNode('ctx2 * pers1', node_name='constr2')
        mb.specifyConstructNode('constr2 * pers2 + ctx2', node_name='constr3', is_observable=True)

    def test_model_checker_using_set_model(self):
        mod = Model()
        mb = ModelBuilder(mod)

        # should return model which was previously set
        mmm = mb._checkModel(None)
        self.assertIs(mb.model, mmm)

    def test_model_checker_for_specified_model(self):
        mod = Model()
        mb = ModelBuilder()

        # should return same model as was given
        mmm = mb._checkModel(mod)
        self.assertIs(mmm, mod)

    def test_model_checker_no_model(self):
        mb = ModelBuilder()

        self.assertRaises(ValueError, mb._checkModel, None)

    def test_node_checker_on_given_nodes(self):
        mb = ModelBuilder(Model())

        infoFlow = ur'ctx2 -> constr2\n ctx2 -> constr3\n constr2 -> constr3\n pers1 -> constr2\n pers2 -> constr3'
        mb.updateDSL(infoFlow, DSL_type='info-flow')

        node = mb._checkNode(mb.model, 'ctx2')
        self.assertEqual(node.name, 'ctx2')

    def test_update_dsl_adds_nodes(self):
        mb = ModelBuilder(Model())

        infoFlow = ur'ctx2 -> constr2\n ctx2 -> constr3\n constr2 -> constr3\n pers1 -> constr2\n pers2 -> constr3'
        mb.updateDSL(infoFlow, DSL_type='info-flow')

        nodes = ['ctx2', 'constr2', 'constr3', 'pers1', 'pers2']
        for node in nodes:
            self.assertEqual(node, mb.model.getNode(node).name)

    def test_step_through_nodes(self):
        """
        tests that the use of getNextNode and specifyNode effectively steps through all the nodes.
        """
        # setup
        mb = ModelBuilder(Model())

        # === "draw" ===
        info_flow = ur'n1a -> n2\n n1b -> n2\n n2 -> n3a\n n2 -> n3b\n n3a -> n4\n n3b -> n4'
        mb.updateDSL(info_flow, DSL_type='info-flow')

        # first node must be those with no inflows
        nodes = ['n1a', 'n1b']
        current_node = mb.getNextNode()
        self.assertIn(current_node.name, nodes)
        mb.specifyContextNode('this is just filler for now')

        # 2nd node is the other one with no inflow
        nodes.remove(current_node.name)
        current_node = mb.getNextNode()
        self.assertEqual(current_node.name, nodes[0])
        mb.specifyPersonalityNode('more filler')

        # 3rd node
        current_node = mb.getNextNode()
        self.assertEqual(current_node.name, 'n2')
        mb.specifyConstructNode('whatevah whatevah')

        # 4th node
        nodes = ['n3a', 'n3b']
        current_node = mb.getNextNode()
        self.assertIn(current_node.name, nodes)
        mb.specifyConstructNode('whatevah whatevah')

        # 5th node
        nodes.remove(current_node.name)
        current_node = mb.getNextNode()
        self.assertEqual(current_node.name, nodes[0])
        mb.specifyConstructNode('whatevah whatevah')

        # last node
        current_node = mb.getNextNode()
        self.assertEqual(current_node.name, 'n4')
        mb.specifyConstructNode('whatevah whatevah')
