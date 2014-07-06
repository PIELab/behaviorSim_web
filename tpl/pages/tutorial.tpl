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
  
        function sign(x) {
            // returns the sign of a number as +-1
            return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
        }
        
        // functions for converting UI slider values into more interesting model values
        function mapThresh(percent){
            return percent/10;
        }
        function mapScale(percent){
            return percent/5-10;
        }
        
        // UI SLIDERS
        var recompute_pa = function(){
            for (var i = 0; i < se_graph.series[0].data.length; i++) {
                var SE = se_graph.series[0].data[i].y;
                var val = SE * scale;
                if ( pa_data.length > 1 ){
                    var lastVal = pa_data[pa_data.length-1].y;
                    var delta = val - lastVal;
                    if ( Math.abs(delta) > thresh ){
                        val = lastVal + thresh*sign(delta);
                    }
                }
                pa_graph.series[0].data[i].y = val;
            }
        };
        
        $(function() {
            $( "#scale_slider" ).slider({value:70});
            
            $( "#response_slider" ).slider({value:10});
            
            $( "#time_slider").slider({step:1, value:[100]});
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
                data: [ 
                    { x: 0, y: 1 }, 
                    { x: 1, y: 1 }, 
                    { x: 2, y: 5 }, 
                    { x: 3, y: 5 }, 
                    { x: 4, y: 5 },
                    { x: 5, y: 1 },
                    { x: 6, y: 1 },
                    { x: 7, y: 1 },
                    { x: 8, y: 1 },
                    { x: 9, y: 1 } ]
            }]
        });
        
        var pa_data = [];
        for (var i = 0; i < se_graph.series[0].data.length; i++) {
            var SE = se_graph.series[0].data[i].y;
            var val = SE * scale;
            if ( pa_data.length > 1 ){
                var lastVal = pa_data[pa_data.length-1].y;
                var delta = val - lastVal;
                if ( Math.abs(delta) > thresh ){
                    val = lastVal + thresh*sign(delta);
                }
            }
            
            pa_data.push({x: i, y: val});
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
