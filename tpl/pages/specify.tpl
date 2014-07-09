% include ('tpl/pageBits/header')

<body>

    <meta charset="utf-8">
    <title>behaviorSim model specification</title>
    <meta name="description" content="behavioral modeling for all">
    <meta name="author" content="USF PIE Lab">
    
    <!-- chosen -->
    <link rel="stylesheet" href="{{CONFIG.CHOSEN_CSS_URL}}">

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

    <div class='row'>
        <p>
            Now let's dive a little deeper and think about what each connection between variables means. Let's focus on the variable highlighted in your graph below.
        </p>
    </div>
    <div class='row'>
        
        <div id='infoFlow'>
                <div id="mainCanvas"> </div>
        </div>
        
    </div>
    <div class='row'>

        <p>
            Let's start out with the "source verticies" (variables without any inflows). Since they have no variables going into them, we have to make an assumption about how they change over time. 
        </p>
    </div>
        
    <div>
        <div class='row'>
            <div class='title'>
                Selected Node
            </div>
            <div class='left-column'>
                <div id="closeupCanvas"> </div>
            </div>
            <div class='right-column'>
                <div class='row'>
                         For VAR NAME, 
                         use        
                        <select id="model-selector" data-placeholder="default-choice..." class="chosen-select" style="width:250px;" tabindex="4">
                            <option value="linear-combination">Linear Combination</option>
                            <option value="fluid-flow">Fluid-Flow Analogy</option>
                            <option value="other">Other</option>
                        </select>
                </div>
                <div class='row'>
                    <div class="left-column" id='modeling-options'>
                        PLACEHOLDER
                    </div>
                    <div class="right-column">
                        <img src="http://zone.ni.com/images/reference/en-XX/help/371361J-01/guid-8fc111e7-da03-4524-b642-5499c58894f9-help-web.png" >
                    </div>
                </div>
            </div>
        </div>

        <div class='row'>
        <a href="#" class="disabledButton">Previous Node</a>
        <a href="#" class="myButton">Next Node</a>
        <a href="#" class="disabledButton">Done</a>
       </div>
        %include('tpl/pageBits/nav')

    </div>
    
    <script type='text/coffeescript'>
        ### script for controlling responsive modeling param form ###
        modelingOptions = document.getElementById('modeling-options')
        modelSelection  = document.getElementById('model-selector')
         
        $listen = (target, name, callback) ->
            # shortcut addListener function
            if target.addEventListener
                target.addEventListener name, callback, false
            else
                target.attachEvent "on#{name}", callback
                
        $ getOptionsForSelection = (selected) ->
            # returns html with options section for given selection
            if selected == 'linear-combination'
                return '''
                        <strong>constr2 = c1 * ctx2</strong>
                        <br><br> 
                        <form> 
                            c1 = <input type="text" name="c1"> 
                        </form> 
                    '''
            else if selected == 'fluid-flow'
                return '''
                        <strong>constr2 = ...</strong>
                        <form>
                            ...
                        </form>
                    '''
            else if selected == 'other'
                return '''
                        <strong> constr2 = f( ctx2 ) </strong
                        <form>
                            <input type="paragraph" name="code">
                        </form>
                    '''
            else
                return "unrecognized selection '"+selected+"'"
                
        $listen modelSelection, 'change', =>
            modelingOptions.innerHTML = getOptionsForSelection( modelSelection.value )
            
        # initial setting of the content section
        modelingOptions.innerHTML = getOptionsForSelection( modelSelection.value )
        
    </script>

    <script type="text/coffeescript">
        selectedNode = "constr2"  # TODO: use something like  simManager.getNextNodeToSpec() 
        ### main diagram display (with highlighted node) ###
        @controller = new Controller

        main_paper = Raphael "mainCanvas", 400, 400

        # TODO: use something like simManger.getNextNodeToSpec() here too
        sampleText = """
        {{ !simManager.getInfoFlowDSL('constr2') }}
        """

        raphaelCanvas = document.getElementById("mainCanvas")

        # initialize the view
        @controller.makeItGo(sampleText, main_paper, false)

        ### close up display ###
        closeup_paper = Raphael "closeupCanvas", 200, 200  #NOTE: these numbers dont matter?

        # TODO: use something like simManger.getNextNodeToSpec() here too
        text = """
        {{ !simManager.getInfoFlowDSL_closeup('constr2') }}
        """
        # initialize the view
        @controller.makeItGo(text, closeup_paper, false)
    </script>

</body>
