function getInputsOf(node_id){
    try{
        _result = []
        for (node in model_builder._graph._nodes[node_id]._inEdges){
            _result.push(node)
        }
        return _result
    } catch(e) {
        if (e.name == 'TypeError') {
            return []
        } else {
            throw e;
        }
    }
}

function findElementByText(text) {
  /* finds and returns the tspan containing the given text
   * if the element has no children.
   * Useful for retrieving a box in the diagram. NOTE: why did I do this?
   */
  var jSpot=$("tspan:contains("+text+")")
        .filter(function(){ return $(this).children().length === 0;})
        .parent();  // because you asked the parent of that element

  return jSpot;
}

function update_selected_node_details(){
    // updates the node spec details widget
    inflows = getInputsOf(model_builder.selected_node);
    if (inflows.length > 0){
        $('#modeling-spec').show()
        $('#source-spec').hide()
    } else {
        $('#modeling-spec').hide()
        $('#source-spec').show()
    }
}

