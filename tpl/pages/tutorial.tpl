% include ('tpl/pageBits/header')

<body>

    <style>
    	#pa_graph {
		position:absolute;
		top: 85px; /* 10px; */
		left: 525px;
        }

        #se_graph {
            position:absolute;
            top: 85px; /* 10px; */
            left: 15px;
        }
        
        #scale_slider{
            position:absolute;
            top: 320;
            left: 200;
            width: 370;
        }
        
        #response_slider{
            position:absolute;
            top: 420;
            left: 200;
            width: 370;
        }
        
    </style>
    
    <!-- rickshaw for charts -->
    <link type="text/css" rel="stylesheet" href="/css/rickshaw/detail.css">
    <!-- jqueryUI for slider -->
    <link type="text/css" rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/css/jquery-ui.min.css">
    <script src='//cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/jquery-ui.js'></script>

    <meta charset="utf-8">
    <title>behaviorSim model specification</title>
    <meta name="description" content="behavioral modeling for all">
    <meta name="author" content="USF PIE Lab">
    
    <object type="image/svg+xml" data="/img/tutorial.svg">Your browser does not support SVG. :(</object>
    
    <div id='pa_graph'></div>
    <div id='se_graph'></div>

    <!-- TODO: use (read:fix) this or remove it: -->
    <div id="y_axis"></div>
    
    <div id='scale_slider'></div>
    <div id='response_slider'></div>
    <br>
    Time-Warp:
    <div id='time_slider'></div>
    


    
    <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.9/d3.min.js"></script> 
    <script src="/js/lib/d3.layout.min.js"></script> 
    <script src="//cdnjs.cloudflare.com/ajax/libs/rickshaw/1.4.6/rickshaw.min.js"></script> 
    
    <script> 
        var timeStart = 0;
        var timeStop  = 15;
  
  
        function sign(x) {
            // returns the sign of a number as +-1
            return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
        }
        
        // functions for converting UI slider values into more interesting model values
        function mapThresh(percent){
            return percent/10;
        }
        function mapScale(percent){
            return percent/10;
        }
        
        // sample data to use for SE
        function sampleData(start,stop){
            // returns array of x,y points between time start & stop with a step function in it
            var stp_strt_percent = .20;
            var stp_stop_percent = .50;
            var low = 1;
            var high = 5;
            var t_step = 1;
            
            var range = stop-start;
            var stp_strt = stp_strt_percent*range+start;
            var stp_stop = stp_stop_percent*range+start;
            
            var arr = [];
            for (var i = start; i<stop; i = i+t_step){
                if (i < stp_strt){
                    //before step
                    arr.push({x: i, y: low})
                } else if( i < stp_stop){
                    // in step
                    arr.push({x: i, y: high})
                } else {
                    // after step
                    arr.push({x: i, y: low})
                }
            }
            return arr;
        }
                    
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
        
        // UI SLIDERS
        var recompute_pa = function(){
            for (var i = 0; i < se_graph.series[0].data.length; i++) {
                pa_graph.series[0].data[i].y = PA(se_graph.series[0].data[i].y, i);
            }
        };
        
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
                    var samp = sampleData(timeStart, timeStop);
                    for (var i = 0; i < se_graph.series[0].data.length; i++ ){ 
                        // zero out later points
                        if(i > ui.value/100*se_graph.series[0].data.length){
                            pa_graph.series[0].data[i].y = 0;
                            se_graph.series[0].data[i].y = 0;
                        // reset earlier points (for when increasing)
                        } else {
                            se_graph.series[0].data[i].y = samp[i].y;
                            pa_graph.series[0].data[i].y = PA(samp[i].y, i);
                        }
                    }
                    pa_graph.render();
                    se_graph.render();
                }
            });
        });
        
        var thresh = mapThresh(10);
        var scale  = mapScale(70);
        
        //var thresh = $( "#response_slider" ).slider('value')/10;
        //var scale  = $( "#scale_slider" ).slider('value')/5-10;
        
        // TIME-SERIES CHARTS:
        
        // TODO: add start_time & make time-steps in days...
        
        var se_graph = new Rickshaw.Graph( {
            element: document.querySelector("#se_graph"), 
            renderer: 'bar',
            stroke: true,
            width: 269, 
            height: 134, 
            series: [{
                name: 'SE',
                color: 'darkred',
                data: sampleData(timeStart,timeStop)
            }]
        });
        
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
        
      /* TODO: get tickmarks to work:
        var pa_xAxis = new Rickshaw.Graph.Axis.Y({
            graph: pa_graph,
            orientation: 'left',
            tickFormat: Rickshaw.Fixtures.Number.formatKMBT
        });
        
        var se_xAxis = new Rickshaw.Graph.Axis.Y({
            graph: se_graph,
            orientation: 'left',
            tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
            element: document.getElementById('y_axis')
        });
       */
       
      
        var se_hoverDetail = new Rickshaw.Graph.HoverDetail( {
            graph: se_graph,
            yFormatter: function(y){ return y }
        } );
        
        var pa_hoverDetail = new Rickshaw.Graph.HoverDetail( {
            graph: pa_graph,
        } );
        
        
        se_graph.render();
        pa_graph.render();
    
    </script> 

</body>
