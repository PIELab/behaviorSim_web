
function PA(SE, ind){
    var val = SE * scale;
    if ( ind > 0 ){
        var lastVal = pa_data[ind-1].y;
        var delta = val - lastVal;
        if ( Math.abs(delta) > thresh ){
            val = lastVal + thresh*sign(delta);
        }
    }
    return val;
}

var pa_data = [];
for (var i = 0; i < se_graph.series[0].data.length; i++) {
    pa_data.push({x: i, y: PA(se_graph.series[0].data[i].y, i)});
}

var pa_graph = new Rickshaw.Graph( {
    element: document.querySelector("#pa_graph"),
    renderer: 'bar',
    stroke: true,
    width: 269,
    height: 134,
    series: [{
        name: 'PA',
        color: 'steelblue',
        data: pa_data
    }]
});

var recompute_pa = function(){
    for (var i = 0; i < se_graph.series[0].data.length; i++) {
        pa_graph.series[0].data[i].y = PA(se_graph.series[0].data[i].y, i);
    }
};

var pa_hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: pa_graph,
} );

/* TODO: get tickmarks to work:
var pa_xAxis = new Rickshaw.Graph.Axis.Y({
    graph: pa_graph,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
});
*/

pa_graph.render();
