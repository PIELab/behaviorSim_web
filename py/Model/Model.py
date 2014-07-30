__author__ = 'tylarmurray'

from py.Model.InfoFlow.InfoFlowGraph import InfoFlowGraph

class Model(object):
    '''
    This class is used to describe a model. All information needed to describe and simulate a model goes here.
    '''
    def __init__(self):
        self.infoFlowGraph = InfoFlowGraph()

        self.MODEL_CONTEXTS = None
        self.MODEL_CONSTRUCTS = None
        self.MODEL_BEHAVIORS = None

        self.DSL = None
        self.DSL_type = None

        self.infoFlow = InfoFlowGraph()

    def setMeasures(self, contexts, constructs, behaviors):
        self.MODEL_CONTEXTS = contexts
        self.MODEL_CONSTRUCTS = constructs
        self.MODEL_BEHAVIORS = behaviors

    def updateDSL(self, newDSL, type="info-flow"):
        '''
        sets the Diagram Specification Language spec for the model
        '''
        self.DSL = newDSL
        self.DSL_type = type
        self.infoFlow = InfoFlowGraph(DSL=newDSL)
