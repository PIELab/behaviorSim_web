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

function normal_random(mean, variance) {
    /*
    generates approximation of gaussian random using polar method
    */
    if (mean == undefined) mean = 0.0;
    if (variance == undefined) variance = 1.0;
    var V1, V2, S;
    do {
        var U1 = Math.random();
        var U2 = Math.random();
        V1 = 2 * U1 - 1;
        V2 = 2 * U2 - 1;
	    S = V1 * V1 + V2 * V2;
     } while (S > 1);
     X = Math.sqrt(-2 * Math.log(S) / S) * V1;
     // Y = Math.sqrt(-2 * Math.log(S) / S) * V2;
     X = mean + Math.sqrt(variance) * X;
     // Y = mean + Math.sqrt(variance) * Y ;
     return X;
 }

