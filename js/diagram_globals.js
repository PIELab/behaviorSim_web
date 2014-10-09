function getInputsOf(node_id){
    try{
        _result = []
        for (node in graph._nodes[node_id]._inEdges){
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
    inflows = getInputsOf(graph.selected_node);
    if (inflows.length > 0){
        $('#modeling-spec').show()
        $('#source-spec').hide()
    } else {
        $('#modeling-spec').hide()
        $('#source-spec').show()
    }
}

function update_selected_node_texts(){
    // updates all tspans of class selected_node_text to display new node name
    // and tspans of class node_inflow_count to contain proper count
    $('.selected_node_text').text(graph.selected_node);

    $('.node_inflow_count').text(getInputsOf(graph.selected_node).length);

    $('.selected_node_functional_form').text(graph.get_selected_node_functional_form())
}
