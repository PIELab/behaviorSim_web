__author__ = '7yl4r'

class ModelBuilder(object):
    """
    Manages the steps of builiding a Model.
    """

    def __init__(self, model=None):
        """
        :param model: model object to manipulate (must be passed to each method if not set)
        """
        # booleans to represent state of model builiding process:
        self.measurementsSet = False  # true if context/behavior vars have been given
        self.connectionsMade = False  # true if vars/construct node connections have been drawn
        self.formulated      = False  # true if node connection formulas have been specified

        self.selectedNode = None  # used like a cursor which contains the name of the node we are focused on

        if model is not None:
            self.setModel(model)

    def setModel(self, modelObj):
        """
        sets the model to work with so that it doesn't need to be passed all the time
        """
        self.model = modelObj

    def checkModel(self, model):
        """
        checks to ensure that the given model object is usable.
        if it is not, use self.model if possible.
        if not, raise error.
        """
        if model is not None:
            # model is good
            return model
        elif self.model is not None:
            # self.model is good
            return self.model
        else:
            raise ValueError('Model has not been set and no model was given to work with! (both are None)')

    def getNextNode(self, model=None):
        """
        returns the next node which needs specification. assumes DSL is in place.
        """
        model = self.checkModel(model)

        if self.DSL is not None:
            self.selectedNode = model.infoFlow.getNextNodeToSpec()
            return self.selectedNode
        else:
            raise AssertionError('DSL must be set before specifying nodes.')


    def getInfoFlowDSL_closeup(self, selectedNode, model=None):
        """
        returns Diagram Spec Language showing only immediate neighbors of selectedNode, with selectedNode
        """
        model = self.checkModel(model)

        # TODO: use selectedNode here...
        return ur'ctx2 -> constr2\n constr2 -> constr3\n constr2 {red}'