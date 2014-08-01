"""
This class manages a simulation and all data/interaction surrounding it.
"""

from itertools import cycle

from py.ModelBuilder import ModelBuilder
from py.Model.Model import Model

from py.config import DEBUG

TIME_SCALES = ['instantaneous', 'hour', 'day', 'week', 'month', 'year', 'lifetime']  # a list of available time scale values
HIGHLIGHT_COLOR = 'red'  # color of highlighted nodes on DSL graphs

class SimManager(ModelBuilder):
    def __init__(self):
        self.setModel(Model())
        super(SimManager, self).__init__()

    def addMeasures(self, contexts, constructs, behaviors):
        """
        Adds given measurements to the model.
        TODO: Should iterate over cntx, constr, and behav then create var in the model instance for each var...
        """
        self.model.setMeasures(contexts, constructs, behaviors)
        self.measurementsSet = True

    def _initInfoFlowDSL(self):
        """
        Generates random-ish diagram using constructs, constructs, and behaviors to get us started.
        """
        DSLstr = ''

        try:
            # create cycle to loop through constructs so we get even distribution of connections
            if self.model.MODEL_CONSTRUCTS is not None and self.model.MODEL_CONSTRUCTS > 0:
                cstr = cycle(self.model.MODEL_CONSTRUCTS)
            else:
                cstr = cycle(['???'])

            # connect contexts to constructs
            for ctx in self.model.MODEL_CONTEXTS:
                DSLstr += ctx + r' -> ' + cstr.next() +'\n'

            # connect constructs to behaviors
            for bvr in self.model.MODEL_BEHAVIORS:
                DSLstr += cstr.next() + ' -> ' + bvr + '\n'
        except TypeError as e:
            print '\n\n context, construct, and/or behaviors have not been set yet. Cannot make graph!\n\n'
            if DEBUG:
                return ur'ctx1 -> constr1\n ctx2 -> constr1\n ctx2 -> constr2\n constr2 -> constr3\n constr3 -> behavior\n constr1 -> behavior\n'
            else:
                raise

        return DSLstr

    def getInfoFlowDSL(self, highlightedNode=None):
        """
        returns Diagram Specification Language for current information flow diagram
        """
        if self.model.DSL is not None:
            return self.model.DSL
        else:
            DSLstr = self._initInfoFlowDSL()

            if highlightedNode is not None:
                DSLstr+=ur'\n'+str(highlightedNode)+ur' {'+HIGHLIGHT_COLOR+ur'}\n'

            return DSLstr


