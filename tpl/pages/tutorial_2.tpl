% include ('tpl/pageBits/header')

<body>

    <style>
        #ve_graph {
		position:absolute;
		top: 414px; /* 10px; */
		left: 16px;
        }

        #vp_graph {
            position:absolute;
            top: 85px; /* 10px; */
            left: 16px;
        }

    	#pa_graph {
		position:absolute;
		top: 245px; /* 10px; */
		left: 965px;
        }

        #se_graph {
            position:absolute;
            top: 245px; /* 10px; */
            left: 455px;
        }
        
        #scale_slider{
            position:absolute;
            top: 480;
            left: 640;
            width: 370;
        }
        
        #response_slider{
            position:absolute;
            top: 580;
            left: 640;
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
    
    <object type="image/svg+xml" data="/img/tutorial_p2.svg">Your browser does not support SVG. :(</object>
    
    <div id='pa_graph'></div>
    <div id='se_graph'></div>
    <div id='vp_graph'></div>
    <div id='ve_graph'></div>

    <!-- TODO: use (read:fix) this or remove it: -->
    <div id="y_axis"></div>
    
    <div id='scale_slider'></div>
    <div id='response_slider'></div>

    <br>

    <div>
        <a href="/tutorial/3" class="myButton">I'm ready to add my own variables.</a>
        <a href="#" class="disabledButton">Explain this more. (TODO: with tooltips)</a>
    </div>



    <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.9/d3.min.js"></script> 
    <script src="/js/lib/d3.layout.min.js"></script> 
    <script src="//cdnjs.cloudflare.com/ajax/libs/rickshaw/1.4.6/rickshaw.min.js"></script>

    <script type="text/javascript" src="/js/tutorial/base_config.js"></script>
    <script>


    </script>
    <script type="text/javascript" src="/js/tutorial/vp_graph.js"></script>
    <script type="text/javascript" src="/js/tutorial/ve_graph.js"></script>
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
            content: "<p> Now We've added Verbal Persuasion and Vicarious Experience.</p>",
            highlightTarget: true,
            nextButton: true,
            target: $('#vp_graph'),
            my: 'left center',
            at: 'right center'
        },
        {
            content: '<p> VP and VE are simply added together to get SE.</p>',
            highlightTarget: false,
            nextButton: true,
            target: $('#se_graph'),
            my: 'bottom center',
            at: 'top center'
        },
        {
            content: '<p> The functional definition of PA(SE) remains the same. </p>',
            highlightTarget: false,
            nextButton: true,
            target: $('#pa_graph'),
            my: 'bottom right',
            at: 'top left'
        },
        {
            content: '<p> In a real experiment we can measure VP and VE as "context variables". </p>',
            highlightTarget: false,
            nextButton: true,
            target: $('#ve_graph'),
            my: 'bottom center',
            at: 'top center'
        },
        {
            content: '<p> SE is an "internal state variable" of this human system model. </p>',
            highlightTarget: false,
            nextButton: true,
            target: $('#se_graph'),
            my: 'bottom center',
            at: 'top center'
        },
        {
            content: '<p> and PA is a measured behavior. </p>',
            highlightTarget: false,
            nextButton: true,
            target: $('#pa_graph'),
            my: 'bottom center',
            at: 'top center'
        }
        ];

        var tour = new Tourist.Tour({
          steps: steps,
          tipClass: 'Bootstrap',
          tipOptions:{ showEffect: 'slidein' }
        });
        tour.start();
    </script>
</body>
