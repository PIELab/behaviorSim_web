'''
This class manages a simulation and all data/interaction surrounding it.
'''

from py import webSocketParser

DELTA_T = 0.1 # seconds between updates

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

    # === NOTE: sockets are not used currently ===================================================
    def sendAll(self, m, originator=None, supress=False):
        # sends message to all open websocket connections except for the originator websocket
        for sock in self.sockets:
            if sock != originator:
                sock.send(m)
        if supress == False:
            print 'broadcast message: ', m, ' from ...' #TODO: get originator client ID
    # ============================================================================================
