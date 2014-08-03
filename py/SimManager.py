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
        super(SimManager, self).__init__()
        self.setModel(Model())

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
            # add constructs
            for ctr in self.model.MODEL_CONSTRUCTS:
                DSLstr += ctr + '\n'

            # add contexts
            for ctx in self.model.MODEL_CONTEXTS:
                DSLstr += ctx + '\n'

            # add constructs
            for bvr in self.model.MODEL_BEHAVIORS:
                DSLstr += bvr + '\n'
        except TypeError as e:
            DSLstr = ''

        return DSLstr

    def getInfoFlowDSL(self, highlightedNode=None):
        """
        returns Diagram Specification Language for current information flow diagram
        """
        if self.model.DSL is not None:
            dsl_str = self.model.DSL
        else:
            dsl_str = self._initInfoFlowDSL()

        if highlightedNode is not None:
            dsl_str += ur'\n'+str(highlightedNode.name)+ur' {'+HIGHLIGHT_COLOR+ur'}\n'

        return dsl_str


