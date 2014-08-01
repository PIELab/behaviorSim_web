from py.Model.directed_graph.Node import Node

__author__ = 'tylarmurray'

NODE_TYPES = ['context', 'construct', 'behavior']


class InfoFlowNode(Node):
    """
    a node in the infoFlow diagram
    """
    def __init__(self, name):
        super(InfoFlowNode, self).__init__(name)
        self.defined = False  # true if node has been specified
        self._formulation = None  # string used to specify node calculation equations

    def readyToSpec(self):
        """
        :return: true if node is ready for specification (if all parents are specified)
        """
        for parent in self.parents:
            if not parent.defined:
                return False
        else:
            return True

    def set_formulation(self, new_formulation):
        self._formulation = new_formulation
        self.defined = True