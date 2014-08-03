from py.Model.directed_graph.Node import Node

__author__ = 'tylar'


class DirectedGraph(object):
    """
    defines a (simplified) directed graph to represent the state of a model during the specification process.
    """
    def __init__(self, DSL=None):
        self._nodes = list()
        if DSL is None:
            return
        else:
            self.createFromDSL(DSL)

    def getNode(self, nodeName):
        """
        returns node object for given node name
        :param nodeName: node to search for
        :return: node object if exists, else None
        """
        for node in self._nodes:
            if node.name == nodeName:
                return node
        else:
            return None

    def hasNode(self, nodeName):
        """
        returns true if given node is in graph
        :param nodeName: name of node to search for
        :return:
        """
        for node in self._nodes:
            if nodeName == node.name:
                return True
        else:
            return False

    def addNode(self, nodeName):
        """
        adds node if exists
        :param nodeName: node to add
        :return: 'added' if added, 'exists' if already exists
        """
        if self.hasNode(nodeName):
            return 'exists'
        else:
            self._nodes.append(Node(nodeName))
            return 'added'

    def connect(self, fromNode, toNode, connectType=None):
        """
        creates directed connection between given nodes
        :param fromNode: node name which connection comes from
        :param toNode: node name which connection goes to
        :param connectType: "type" of connection. (used for complex connections) if unspecified, assume simple connect
        :return:
        """
        if (connectType is None
            or connectType == '->'):
            self.getNode(fromNode).addChild(self.getNode(toNode))
            self.getNode(toNode).addParent(self.getNode(fromNode))
        else:
            raise NotImplementedError('node connection type"'+connectType+'" not implemented')

    def reset(self):
        """
        clears all nodes
        """
        self._nodes = list()

    def createFromDSL(self, DSL):
        """
        creates directed graph from given dsl.
        :param DSL: diagram specification language string
        :return:
        """
        self.reset()
        for line in DSL.split('\\n'):
            tokens = line.split()
            try:
                fromNode = tokens[0]
                op = tokens[1]
                toNode = tokens[2]
            except IndexError:
                raise Warning('skipping malformed dsl line"'+line+'"')
                continue
            self.addNode(fromNode)
            self.addNode(toNode)
            self.connect(fromNode, toNode, connectType=op)