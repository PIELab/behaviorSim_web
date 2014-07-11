var ve_data = sampleData(timeStart, timeStop, .3, .7, 2, 4);

var ve_graph = new Rickshaw.Graph( {
    element: document.querySelector("#ve_graph"),
    renderer: 'bar',
    stroke: true,
    width: 269,
    height: 134,
    series: [{
        name: 'VE',
        color: 'green',
        data: ve_data
    }]
});


var ve_hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: ve_graph,
    yFormatter: function(y){ return y }
} );

/* TODO: get tickmarks to work:
var ve_xAxis = new Rickshaw.Graph.Axis.Y({
    graph: ve_graph,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    element: document.getElementById('y_axis')
});
*/

ve_graph.render();
