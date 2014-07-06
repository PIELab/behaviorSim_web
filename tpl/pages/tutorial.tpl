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

    </style>
    

    <meta charset="utf-8">
    <title>behaviorSim model specification</title>
    <meta name="description" content="behavioral modeling for all">
    <meta name="author" content="USF PIE Lab">
    
    <object type="image/svg+xml" data="/img/tutorial.svg">Your browser does not support SVG. :(</object>
    
    <div id='pa_graph'></div>
    <div id='se_graph'></div>
    
    <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.9/d3.min.js"></script> 
    <script src="/js/lib/d3.layout.min.js"></script> 
    <script src="//cdnjs.cloudflare.com/ajax/libs/rickshaw/1.4.6/rickshaw.min.js"></script> 
    
    <script> 
  
    function sign(x) {
        // returns the sign of a number as +-1
        return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
    }
    
    var se_graph = new Rickshaw.Graph( {
        element: document.querySelector("#se_graph"), 
        width: 269, 
        height: 134, 
        series: [{
            color: 'darkred',
            data: [ 
                { x: 0, y: 1 }, 
                { x: 1, y: 1 }, 
                { x: 2, y: 5 }, 
                { x: 3, y: 5 }, 
                { x: 4, y: 1 },
                { x: 5, y: 1 },
                { x: 6, y: 1 },
                { x: 7, y: 1 },
                { x: 8, y: 1 },
                { x: 9, y: 1 } ]
        }]
    });
    
    var thresh = 1; // TODO: set using slider
    var scale  = 1; // TODO: set using slider
    
    var pa_data = [];
    for (var i = 0; i < se_graph.series[0].data.length; i++) {
        var SE = se_graph.series[0].data[i].y;
        var val = SE * scale;
        var lastVal = pa_data[pa_data.length-1];
        var delta = val - lastVal;
        
        if ( Math.abs(delta) > thresh ){
            val = lastVal + thresh*sign(delta);
        }
        pa_data.push({x: i, y: val});
    }
     
    var pa_graph = new Rickshaw.Graph( {
        element: document.querySelector("#pa_graph"), 
        width: 269, 
        height: 134, 
        series: [{
            color: 'steelblue',
            data: pa_data
        }]
    });
     
    se_graph.render();
    pa_graph.render();
     
    </script> 

</body>
