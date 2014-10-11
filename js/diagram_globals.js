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

