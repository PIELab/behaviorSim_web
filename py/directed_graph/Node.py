__author__ = 'tylar'

class Node(object):
    '''
    Node in the Directed Graph
    '''
    def __init__(self, name):
        self.name = name
        self.children = list()
        self.parents  = list()

    def addChild(self, childObj):
        self.children.append(childObj)

    def addParent(self, parentObj):
        self.parents.append(parentObj)

