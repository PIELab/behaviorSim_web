function SE(vp, ve){
    return vp+ve;
}

var se_data = [];
for (var i = 0; i < ve_data.length; i++) {
    se_data.push({x: i, y: SE(ve_data[i].y, vp_data[i].y)});
}

var se_graph = new Rickshaw.Graph( {
    element: document.querySelector("#se_graph"),
    renderer: 'bar',
    stroke: true,
    width: 269,
    height: 134,
    series: [{
        name: 'SE',
        color: 'darkred',
        data: se_data
    }]
});


var se_hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: se_graph,
    yFormatter: function(y){ return y }
} );

/* TODO: get tickmarks to work:
var se_xAxis = new Rickshaw.Graph.Axis.Y({
    graph: se_graph,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    element: document.getElementById('y_axis')
});
*/

se_graph.render();
