var vp_data = sampleData(timeStart, timeStop, .2, .5, 1, 6);

var vp_graph = new Rickshaw.Graph( {
    element: document.querySelector("#vp_graph"),
    renderer: 'bar',
    stroke: true,
    width: 269,
    height: 134,
    series: [{
        name: 'VP',
        color: 'orange',
        data: vp_data
    }]
});


var vp_hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: vp_graph,
    yFormatter: function(y){ return y }
} );

/* TODO: get tickmarks to work:
var vp_xAxis = new Rickshaw.Graph.Axis.Y({
    graph: vp_graph,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    element: document.getElementById('y_axis')
});
*/

vp_graph.render();
