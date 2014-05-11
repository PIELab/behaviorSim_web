'''
This class manages a simulation and all data/interaction surrounding it.
'''

from py import webSocketParser

DELTA_T = 0.1 # seconds between updates

class SimManager(object):
    def __init__(self):
        self.sockets = list() # list of all websocket connections open 
        # self.environment = Environment()

        self.parseMessage = webSocketParser.parse


    def sendAll(self, m, originator=None, supress=False):
        # sends message to all open websocket connections except for the originator websocket
        for sock in self.sockets:
            if sock != originator:
                sock.send(m)
        if supress == False:
            print 'broadcast message: ', m, ' from ...' #TODO: get originator client ID
