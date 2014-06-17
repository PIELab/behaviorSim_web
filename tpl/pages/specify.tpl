% include ('tpl/pageBits/header')

<body>

    <meta charset="utf-8">
    <title>diagramophone</title>
    <meta name="description" content="diagrams for all">
    <meta name="author" content="Monica Dinculescu">

    <!-- prettify things (diagramophone) -->
    <link href="js/lib/diagramophone/lib/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet/less" type="text/css" href="js/lib/diagramophone/style.less">
    <script src="js/lib/diagramophone/lib/less-1.3.0.min.js" type="text/javascript"></script>
    <!-- chosen -->
    <link rel="stylesheet" href="{{CONFIG.CHOSEN_CSS_URL}}">

    <!-- things you need to run -->
    <script src="js/lib/diagramophone/lib/raphael-min.js" type="text/javascript"></script>
    <script src="js/lib/diagramophone/lib/coffee-script.js" type="text/javascript"></script>


    <!-- my stuff -->
    <script src="js/lib/diagramophone/dramagrama.coffee" type="text/coffeescript"></script>
    <script src="js/lib/diagramophone/drawer.coffee" type="text/coffeescript"></script>
    <script src="js/lib/diagramophone/parser.coffee" type="text/coffeescript"></script>

    <!-- fonts -->
    <link href='http://fonts.googleapis.com/css?family=Yanone+Kaffeesatz' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Shadows+Into+Light+Two' rel='stylesheet' type='text/css'>

    <!-- svg to canvas (so then i can image it) -->
    <script type="text/javascript" src="js/lib/diagramophone/lib/rgbcolor.js"></script>
    <script type="text/javascript" src="js/lib/diagramophone/lib/canvg.js"></script>

    <p>
        Now let's dive a little deeper and think about what each connection between variables means. Let's focus on the variable highlighted in your graph below.
    </p>
    
    <br>
    
    <div id='infoFlow'>
            <div id="mainCanvas"> </div>
    </div>
    
    <br>

    <p>
        Let's start out with the "source verticies" (variables without any inflows). Since they have no variables going into them, we have to make an assumption about how they change over time. 
    </p>

    <div>
        <div class="inline">
            <div>
                <div id="closeupCanvas"> </div>
            </div>
            <div>
                Selected Node
            </div>
        </div>
        <div class="inline">
            <div>
		         <div class="inline">
		             For VAR NAME, 
		         </div>
		         <div class="inline">
		             PULLDOWNSELECTBOX
		         </div>
            </div>
            <div class="inline">
                OPTIONS FOR SELCTION
            </div>
            <div class="inline">
                TIME SERIES FOR NODE
            </div>
        </div>


    </div>

    <script type="text/coffeescript">
        selectedNode = "constr2"  # TODO: use something like simManger.getNextNodeToSpec()
        ### main diagram display (with highlighted node) ###
        @controller = new Controller

        main_paper = Raphael "mainCanvas", 400, 400

        # TODO: use something like simManger.getNextNodeToSpec() here too
        sampleText = """
        {{ !simManager.getInfoFlowDSL('constr2') }}
        """

        $listen = (target, name, callback) ->
            if target.addEventListener
                target.addEventListener name, callback, false
            else
                target.attachEvent "on#{name}", callback

        raphaelCanvas = document.getElementById("mainCanvas")

        # initialize the view
        @controller.makeItGo(sampleText, main_paper, false)

        ### close up display ###
        closeup_paper = Raphael "closeupCanvas", 400, 400

        # TODO: use something like simManger.getNextNodeToSpec() here too
        text = """
        {{ !simManager.getInfoFlowDSL_closeup('constr2') }}
        """
        # initialize the view
        @controller.makeItGo(text, closeup_paper, false)
    </script>

	<div>
    <a href="#" class="disabledButton">Previous Node</a>
    <a href="#" class="myButton">Next Node</a>
    <a href="#" class="disabledButton">Done</a>
   </div>
	%include('tpl/pageBits/nav')
</body>
