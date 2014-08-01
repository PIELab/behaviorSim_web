__author__ = 'tylarmurray'

from py.Model.InfoFlow.InfoFlowGraph import InfoFlowGraph

class Model(InfoFlowGraph):
    """
    This class is used to describe a model. All information needed to describe and simulate a model goes here.
    Basic model information is covered by the InfoFlowGraph implementation, but this class contains additional
    information about the model to make it easier to interface with and use.
    """
    def __init__(self, **kwargs):
        self.contexts = dict()  # context vars which flow in from environment
        self.constructs = dict()  # construct vars (internal state of system)
        self.personalities = dict()  # vars which are constant throughout life of model
        self.observables = dict()  # constructs which are directly observable (behaviors)

        self.MODEL_CONTEXTS = None
        self.MODEL_CONSTRUCTS = None
        self.MODEL_BEHAVIORS = None

        self.DSL = None

        super(Model, self).__init__(**kwargs)

    def setMeasures(self, contexts, constructs, behaviors):
        self.MODEL_CONTEXTS = contexts
        self.MODEL_CONSTRUCTS = constructs
        self.MODEL_BEHAVIORS = behaviors

    def updateDSL(self, newDSL):
        """
        sets the Diagram Specification Language spec for the model
        """
        self.DSL = newDSL
        self.createFromDSL(newDSL)

    def set_node(self, node, node_type, formulation, is_observable=False):
        node.set_formulation(formulation)

        if node_type == 'context':
            self.contexts.update({node.name: node})
        elif node_type == 'construct' or node_type == 'behavior':
            self.constructs.update({node.name: node})
        elif node_type == 'personality':
            self.personalities.update({node.name: node})
        else:
            raise ValueError('unknown node_type "'+node_type+'"')

        if is_observable:
            self.observables.update({node.name: node})