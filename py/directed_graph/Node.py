__author__ = 'tylar'

class Node(object):
    '''
    Node in the Directed Graph
    '''
    def __init__(self, name):
        self.name = name
        self.defined = False # true if node has been defined
        self.children = list()
        self.parents  = list()

    def addChild(self, childObj):
        self.children.append(childObj)

    def addParent(self, parentObj):
        self.parents.append(parentObj)

    def readyToSpec(self):
        '''

        :return: true if node is ready for specification (if all parents are specified)
        '''
        for parent in self.parents:
            if parent.defined == False:
                return False
        else:
            return True