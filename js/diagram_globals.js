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

