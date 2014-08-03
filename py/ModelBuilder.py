__author__ = '7yl4r'

class ModelBuilder(object):
    """
    Manages the steps of builiding a Model. The essential steps are (not necessarily in order):
        * "draw" the information flow of the model.
        * "specify" the formulas at each graph edge
        * "specify" source vertices as:
            1) context vars: information flows in from the environment.
            2) personality vars: values which stay constant over the model's lifetime. Can be:
                a) constant-valued: value must be specified
                b) stochastic: normal distribution assumed, must give mean and standard deviation
    """

    def __init__(self, model=None):
        """
        :param model: model object to manipulate (must be passed to each method if not set)
        """
        # booleans to represent state of model builiding process:
        self.measurementsSet = False  # true if context/behavior vars have been given
        self.connectionsMade = False  # true if vars/construct node connections have been drawn
        self.formulated      = False  # true if node connection formulas have been specified

        self.selected_node = None  # used like a cursor which contains the name of the node we are focused on

        self.model = None
        if model is not None:
            self.setModel(model)

    def setModel(self, model_obj):
        """
        sets the model to work with so that it doesn't need to be passed all the time
        """
        self.model = model_obj

    def _applyInfoFlow(self, infoFlow, model=None):
        """
        Defines connections in the model using given infoFlow string
        """
        #model = self._checkModel(model)  # assumes that model has already been checked
        model.updateDSL(infoFlow)
        self.connectionsMade = True

    def updateDSL(self, newDSL, DSL_type="info-flow", model=None):
        """
        sets the Diagram Specification Language spec for the model
        """
        model = self._checkModel(model)

        if DSL_type == 'info-flow':
            self._applyInfoFlow(newDSL, model)
        else:
            raise NotImplementedError('unknown DSL type "'+type+'"')

    def _checkModel(self, model):
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

    def _checkNode(self, model, node_name):
        """
        checks given node name to ensure good node is selected
        """
        if node_name is None:
            # try to use self.selected_node
            if self.selected_node is not None:
                return self.selected_node
            else:
                raise ValueError('Node cursor location has not been set, and no node_name given to use! (both are None)')
        else:
            # try to lookup the given node name
            node = model.getNode(node_name)
            if node is not None:
                return node
            else:
                # node was not found
                raise ValueError('node "'+str(node_name)+'" not found in model.')

    def getNextNode(self, model=None):
        """
        returns the next node which needs specification. assumes DSL is in place.
        """
        model = self._checkModel(model)

        if self.connectionsMade:
            self.selected_node = model.getNextNodeToSpec()
            return self.selected_node
        else:
            raise AssertionError('DSL must be set before specifying nodes.')

    def getInfoFlowDSL_closeup(self, selected_node, model=None):
        """
        returns Diagram Spec Language showing only immediate neighbors of selected_node, with selected_node
        """
        model = self._checkModel(model)

        # TODO: use selected_node here...
        return ur'ctx2 -> constr2\n constr2 -> constr3\n constr2 {red}'

    def specify_node(self, node_type, model_type, model_options):
        """
        sets the specification for a node.
        :param node_type: defines type of node in question (used to determin how to parse options)
            one of ['context', 'personality', 'construct']
        :param model_type: defines the model used
        :param model_options: model details array to be parsed out
        """

        # TODO: fix all dis:
        if node_type == 'context':
            if model_type == 'fluid-flow':
                pass
            elif model_type == 'linear-combo':
                pass
            else:
                raise ValueError('unknown model_type"'+model_type+'"')
        elif node_type == 'personality':
            pass
        elif node_type == 'construct':
            pass
        else:
            raise ValueError('unknown node_type given "'+node_type+'"')

        print model_options


    def specifyContextNode(self, formulation, node_name=None, model=None):
        """
        specify context vertices
        """
        model = self._checkModel(model)
        node = self._checkNode(model, node_name)

        # set node as a context node
        model.set_node(node, 'context', formulation)

    def specifyPersonalityNode(self, formulation, node_name=None, model=None):
        """
        sets constant or stochastic personality vars
        """
        model = self._checkModel(model)
        node = self._checkNode(model, node_name)

        model.set_node(node, 'personality', formulation)

    def specifyConstructNode(self, formulation, node_name=None, is_observable=False, model=None):
        """
        specifies construct vertex equations
        """
        model = self._checkModel(model)
        node = self._checkNode(model, node_name)

        model.set_node(node, 'construct', formulation, is_observable)