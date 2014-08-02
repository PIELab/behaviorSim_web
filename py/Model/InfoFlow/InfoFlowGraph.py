from py.Model.InfoFlow.InfoFlowNode import InfoFlowNode
from py.Model.directed_graph.DirectedGraph import DirectedGraph

__author__ = 'tylarmurray'


class InfoFlowGraph(DirectedGraph):
    """
    directed graph that uses InfoFlow Nodes instead of regular nodes
    """
    def __init__(self, **kwargs):
        super(InfoFlowGraph, self).__init__(**kwargs)

    # overrides DirectedGraph method
    def addNode(self, nodeName):
        """
        adds node if exists
        :param nodeName: node to add
        :return: 'added' if added, 'exists' if already exists
        """
        print 'adding node "'+nodeName+'"'
        if self.hasNode(nodeName):
            return 'exists'
        else:
            self._nodes.append(InfoFlowNode(nodeName))
            return 'added'

    def isDefined(self):
        """
        :return: True if all nodes are defined (and there is > 0 node)
        """
        if len(self._nodes) < 1:
            return False
        for node in self._nodes:
            if node.defined == False:
                return False
        else:
            return True

    def getNextNodeToSpec(self):
        """

        :return: the name of the next node which needs specification.
        """
        # TODO: "context" nodes don't need to be defined... (they come from the env)

        if len(self._nodes) < 1:
            raise AssertionError('infoFlow graph has no nodes! Must set DSL before requesting nodes to spec.')

        # define nodes with defined (or no) inputs first
        for node in self._nodes:
            if node.defined:
                continue
            elif node.readyToSpec():
                return node
            else:
                continue
        else:
            if self.isDefined():
                return None  # all nodes defined
            else:  # there must be a cycle, select nodes even if not "ready"
                for node in self._nodes:
                    if node.defined:
                        continue
                    else:
                        return node
                else:
                    raise ArithmeticError('something went wrong with node getter. graph not complete, but all nodes are defined.')
