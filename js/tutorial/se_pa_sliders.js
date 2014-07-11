// UI SLIDERS

$(function() {
    $( "#scale_slider" ).slider({value:70,
        change: function(event, ui) {
            scale = mapScale(ui.value);
            recompute_pa();
            pa_graph.render();
        }
    });

    $( "#response_slider" ).slider({value:10,
        change: function(event, ui) {
            thresh = mapThresh(ui.value);
            recompute_pa();
            pa_graph.render();
        }
    });

    $( "#time_slider").slider({step:1, value:[100],
        change: function(event, ui){
            var maxTime = ui.value;
            for (var i = 0; i < se_graph.series[0].data.length; i++ ){
                // zero out later points
                if(i > ui.value/100*se_graph.series[0].data.length){
                    pa_graph.series[0].data[i].y = 0;
                    se_graph.series[0].data[i].y = 0;
                // reset earlier points (for when increasing)
                } else {
                    se_graph.series[0].data[i].y = se_data[i].y;
                    pa_graph.series[0].data[i].y = PA(se_data[i].y, i);
                }
            }
            pa_graph.render();
            se_graph.render();
        }
    });
});