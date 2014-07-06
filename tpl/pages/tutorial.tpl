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
  
    var pa_graph = new Rickshaw.Graph( {
        element: document.querySelector("#pa_graph"), 
        width: 269, 
        height: 134, 
        series: [{
            color: 'steelblue',
            data: [ 
                { x: 0, y: 40 }, 
                { x: 1, y: 49 }, 
                { x: 2, y: 38 }, 
                { x: 3, y: 30 }, 
                { x: 4, y: 32 } ]
        }]
    });
    
    var se_graph = new Rickshaw.Graph( {
        element: document.querySelector("#se_graph"), 
        width: 269, 
        height: 134, 
        series: [{
            color: 'steelblue',
            data: [ 
                { x: 0, y: 40 }, 
                { x: 1, y: 49 }, 
                { x: 2, y: 38 }, 
                { x: 3, y: 30 }, 
                { x: 4, y: 32 } ]
        }]
    });
     
    se_graph.render();
    pa_graph.render();
     
    </script> 

</body>
