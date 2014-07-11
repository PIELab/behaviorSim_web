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

    <!-- (Optional) tourist tour css -->
    <link rel="stylesheet" href="/css/tourist.css" type="text/css" media="screen">
    
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
    <strong>Time-Warp:</strong>
    <table style="width:100%">
        <tr>
            <td align="left">
                Experiment Start
            </td>
            <td align="right">
                Experiment End
            </td>
        </tr>
    </table>
    <div id='time_slider'></div>

    <br>

    <div>
        <a href="/tutorial/2" class="myButton">Let's add more variables!</a>
        <a href="#" class="disabledButton">Explain this more (TODO: with tooltips)</a>
    </div>


    <!-- rickshaw graphs -->
    <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.9/d3.min.js"></script> 
    <script src="/js/lib/d3.layout.min.js"></script> 
    <script src="//cdnjs.cloudflare.com/ajax/libs/rickshaw/1.4.6/rickshaw.min.js"></script>
    <script type="text/javascript" src="/js/tutorial/base_config.js"></script>
    <script>
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
    </script>
    <script type="text/javascript" src="/js/tutorial/se_graph.js"></script>
    <script type="text/javascript" src="/js/tutorial/pa_graph.js"></script>
    <script type="text/javascript" src="/js/tutorial/se_pa_sliders.js"></script>

    <!-- tourist.js guided tour -->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
    <script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.2/backbone-min.js"></script>
    <script src="/js/lib/tourist.js"></script>
    <script type="text/javascript">
        var steps = [{
          content: "<p>So let's imagine that we want to measure physical activity.</p>",
          highlightTarget: true,
          nextButton: true,
          target: $('#pa_graph'),
          my: 'left center',
          at: 'right center'
        }, {
          content: '<p>And we think physical activity (PA) is influenced by self-efficacy.</p>',
          highlightTarget: true,
          nextButton: true,
          target: $('#se_graph'),
          my: 'left center',
          at: 'right center'
        }, {
            content: '<p> These sliders tweak the model which describes how SE influences PA. See how moving them changes the response of PA level.</p>',
            highlightTarget: true,
            nextButton: true,
            target: $('#scale_slider'),
            my: 'bottom center',
            at: 'top center'
        }, {
            content: '<p> This slider represents the current time shown on the charts. This way you can imagine the data part-way through an experiment.</p>',
            highlightTarget: true,
            nextButton: true,
            target: $('#time_slider'),
            my: 'bottom center',
            at: 'bottom center'
        }
        ]

        var tour = new Tourist.Tour({
          steps: steps,
          tipClass: 'Bootstrap',
          tipOptions:{ showEffect: 'slidein' }
        });
        tour.start();
    </script>
</body>
