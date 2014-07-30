'''
This class manages a simulation and all data/interaction surrounding it.
'''

from itertools import cycle
from py.config import DEBUG

from py.directed_graph.InfoFlowGraph import InfoFlowGraph

TIME_SCALES = ['instantaneous', 'hour', 'day', 'week', 'month', 'year', 'lifetime']  # a list of available time scale values
HIGHLIGHT_COLOR = 'red'  # color of highlighted nodes on DSL graphs

class SimManager(object):
    def __init__(self):
        # TODO: replace these with model object instance or something better:
        self.MODEL_CONTEXTS = None
        self.MODEL_CONSTRUCTS = None
        self.MODEL_BEHAVIORS = None
        self.DSL = None
        self.DLS_type = None

        self.infoFlow = InfoFlowGraph()
        self.selectedNode = None  # used like a cursor which contains the name of the node we are focused on

        self.measurementsSet = False  # true if context/behavior vars have been given
        self.connectionsMade = False  # true if vars/construct node connections have been drawn
        self.formulated      = False  # true if node connection formulas have been specified

    def addMeasures(self, contexts, constructs, behaviors):
        '''
        Adds given measurements to the model.
        TODO: Should iterate over cntx, constr, and behav then create var in the model instance for each var...
        '''
        self.MODEL_CONTEXTS = contexts
        self.MODEL_CONSTRUCTS = constructs
        self.MODEL_BEHAVIORS = behaviors
        self.measurementsSet = True

    def _initInfoFlowDSL(self):
        '''
        Generates random-ish diagram using constructs, constructs, and behaviors to get us started.
        '''
        DSLstr = ''

        try:
            # create cycle to loop through constructs so we get even distribution of connections
            if self.MODEL_CONSTRUCTS is not None and self.MODEL_CONSTRUCTS > 0:
                cstr = cycle(self.MODEL_CONSTRUCTS)
            else:
                cstr = cycle(['???'])

            # connect contexts to constructs
            for ctx in self.MODEL_CONTEXTS:
                DSLstr += ctx + r' -> ' + cstr.next() +'\n'

            # connect constructs to behaviors
            for bvr in self.MODEL_BEHAVIORS:
                DSLstr += cstr.next() + ' -> ' + bvr + '\n'
        except TypeError as e:
            print '\n\n context, construct, and/or behaviors have not been set yet. Cannot make graph!\n\n'
            if DEBUG:
                return ur'ctx1 -> constr1\n ctx2 -> constr1\n ctx2 -> constr2\n constr2 -> constr3\n constr3 -> behavior\n constr1 -> behavior\n'
            else:
                raise

        return DSLstr

    def getInfoFlowDSL(self, highlightedNode=None):
        '''
        returns Diagram Specification Language for current information flow diagram
        '''
        if self.DSL is not None:
            return self.DSL
        else:
            DSLstr = self._initInfoFlowDSL()

            if highlightedNode is not None:
                DSLstr+=ur'\n'+str(highlightedNode)+ur' {'+HIGHLIGHT_COLOR+ur'}\n'

            return DSLstr

    def getNextNode(self):
        '''
        returns the next node which needs specification. assumes DSL is in place.
        '''
        if self.DSL is not None:
            self.selectedNode = self.infoFlow.getNextNodeToSpec()
            return self.selectedNode
        else:
            raise AssertionError('DSL must be set before specifying nodes.')


    def getInfoFlowDSL_closeup(self, selectedNode):
        '''
        returns Diagram Spec Language showing only immediate neighbors of selectedNode, with selectedNode
        '''
        # TODO: use selectedNode here...
        return ur'ctx2 -> constr2\n constr2 -> constr3\n constr2 {red}'

    def updateDSL(self, newDSL, type="info-flow"):
        '''
        sets the Diagram Specification Language spec for the model
        '''
        self.DSL = newDSL
        self.DSL_type = type
        self.infoFlow = InfoFlowGraph(DSL=newDSL)
