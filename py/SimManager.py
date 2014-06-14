'''
This class manages a simulation and all data/interaction surrounding it.
'''

from py import webSocketParser
from itertools import cycle
from py.config import DEBUG

TIME_SCALES = ['instantaneous', 'hour', 'day', 'week', 'month', 'year', 'lifetime']  # a list of available time scale values

class SimManager(object):
    def __init__(self):
        # TODO: replace these with model object instance or something better:
        self.MODEL_CONTEXTS = None
        self.MODEL_CONSTRUCTS = None
        self.MODEL_BEHAVIORS = None

        self.measurementsSet = False  # true if context/behavior vars have been given
        self.connectionsMade = False  # true if vars/construct node connections have been drawn
        self.formulated      = False  # true if node connection formulas have been specified
 

        # === NOTE: sockets are not used currently ====================
        self.sockets = list() # list of all websocket connections open 
        # self.environment = Environment()
        # =============================================================

        self.parseMessage = webSocketParser.parse

    def addMeasures(self, contexts, constructs, behaviors):
        '''
        Adds given measurements to the model.
        TODO: Should iterate over cntx, constr, and behav then create var in the model instance for each var...
        '''
        self.MODEL_CONTEXTS = contexts
        self.MODEL_CONSTRUCTS = constructs
        self.MODEL_BEHAVIORS = behaviors
        self.measurementsSet = True

    def getInfoFlowDSL(self):
        '''
        returns Diagram Specification Language for current information flow diagram
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
            print '\n\n context/construct/behaviors have not been set yet. Cannot make graph!\n\n'
            if DEBUG:
                return ur'?? -> ???\n'
            else:
                raise

        return DSLstr


    # === NOTE: sockets are not used currently ===================================================
    def sendAll(self, m, originator=None, supress=False):
        # sends message to all open websocket connections except for the originator websocket
        for sock in self.sockets:
            if sock != originator:
                sock.send(m)
        if supress == False:
            print 'broadcast message: ', m, ' from ...' #TODO: get originator client ID
    # ============================================================================================
