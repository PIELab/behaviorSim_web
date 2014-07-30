__author__ = 'tylarmurray'

from py.directed_graph.Node import Node

NODE_TYPES = ['context', 'construct', 'behavior']

class InfoFlowNode(Node):
    '''
    a node in the infoFlow diagram
    '''
    def __init__(self, name):
        super(InfoFlowNode,self).__init__(name)
        self.defined = False  # true if node has been specified
        self.nodeType = None  # 'type' of node (useful for identifying 'context' nodes)

    def readyToSpec(self):
        '''
        :return: true if node is ready for specification (if all parents are specified)
        '''
        for parent in self.parents:
            if parent.defined == False:
                return False
        else:
            return True