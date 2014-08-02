% include ('tpl/pageBits/header')

% selected_node = simManager.getNextNode()

<body>

    <meta charset="utf-8">
    <title>behaviorSim model specification</title>
    <meta name="description" content="behavioral modeling for all">
    <meta name="author" content="USF PIE Lab">
    
    <!-- chosen -->
    <link rel="stylesheet" href="{{CONFIG.CHOSEN_CSS_URL}}">

    <!-- prettify things (diagramophone) -->
    <link href="/js/lib/diagramophone/lib/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet/less" type="text/css" href="/js/lib/diagramophone/style.less">
    <script src="/js/lib/diagramophone/lib/less-1.3.0.min.js" type="text/javascript"></script>
    <!-- chosen -->
    <link rel="stylesheet" href="{{CONFIG.CHOSEN_CSS_URL}}">

    <!-- things you need to run -->
    <script src="/js/lib/diagramophone/lib/raphael-min.js" type="text/javascript"></script>
    <script src="/js/lib/diagramophone/lib/coffee-script.js" type="text/javascript"></script>


    <!-- my stuff -->
    <script src="/js/lib/diagramophone/dramagrama.coffee" type="text/coffeescript"></script>
    <script src="/js/lib/diagramophone/drawer.coffee" type="text/coffeescript"></script>
    <script src="/js/lib/diagramophone/parser.coffee" type="text/coffeescript"></script>

    <!-- fonts -->
    <link href='http://fonts.googleapis.com/css?family=Yanone+Kaffeesatz' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Shadows+Into+Light+Two' rel='stylesheet' type='text/css'>

    <!-- svg to canvas (so then i can image it) -->
    <script type="text/javascript" src="/js/lib/diagramophone/lib/rgbcolor.js"></script>
    <script type="text/javascript" src="/js/lib/diagramophone/lib/canvg.js"></script>

    <div class='row'>
        <p>
            Now think about what each connection between variables means. Focus on the variable highlighted in your graph below.
        </p>
    </div>
    <div class='row'>
        
        <div id='infoFlow'>
                <div id="mainCanvas"> </div>
        </div>
        
    </div>
    <div class='row'>
        <p>
            Looking at this variable's neighbors, we can see that this variable has
            {{len(selected_node.parents)}} inflows.

            % node_type = None

            % if len(selected_node.parents) > 0:
                % node_type = 'construct'
                This means we must define a formula to describe how information flows into {{selected_node.name}}.
            % else:
                % node_type = 'source'
                So {{selected_node.name}} must be either a context variable, or a personality variable.
            % end
        </p>
    </div>
        
    <div>
        <div class='row'>
            <div id="closeupCanvas"> </div>
        </div>
        % if node_type == 'source':
            <div class="row">
                <div class="left-column">
                    {{selected_node.name}} is a
                    <select id="source-type-selector" class="chosen-select">
                        <option value="personality">personality variable</option>
                        <option value="context">context variable</option>
                    </select>
                </div>
                <div class="right-column" id="source-options">
                    loading source vertex options...
                </div>
            </div>
            <script type='text/coffeescript' src="/js/source_spec_page_controller.coffee"></script>
        % elif node_type == 'construct':
            <div class='row'>
                <div class="left-column">
                    <div class="row">
                         For {{selected_node.name}} use
                        <select id="model-selector" data-placeholder="default-choice..." class="chosen-select" style="width:250px;" tabindex="4">
                            <option value="linear-combination">Linear Combination</option>
                            <option value="fluid-flow">Fluid-Flow Analogy</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <div class='row' id='modeling-options'>
                            loading modeling options...
                    </div>
                </div>
                    <div class="right-column">
                        <img src="http://zone.ni.com/images/reference/en-XX/help/371361J-01/guid-8fc111e7-da03-4524-b642-5499c58894f9-help-web.png" >
                    </div>
                </div>
            </div>
            <script type='text/coffeescript' src="/js/model_spec_page_controller.coffee"></script>
        % else:
            % raise ValueError('unknown node_type "'+node_type+'"')
        % end
        <div class='row'>
            <a href="#" class="disabledButton">Previous Node</a>
            <a href="#" class="myButton" id="submit_node_button">Next Node</a>
            <a href="#" class="disabledButton">Done</a>
       </div>
        <div class="row">
            %include('tpl/pageBits/nav')
        </div>
    </div>
    

    <script type="text/coffeescript">
        selectedNode = "{{selected_node}}"
        ### main diagram display (with highlighted node) ###
        @controller = new Controller

        main_paper = Raphael "mainCanvas", 400, 400

        sampleText = """
        {{ !simManager.getInfoFlowDSL(selected_node) }}
        """

        raphaelCanvas = document.getElementById("mainCanvas")

        # initialize the view
        @controller.makeItGo(sampleText, main_paper, false)

        ### close up display ###
        closeup_paper = Raphael "closeupCanvas", 200, 200  #NOTE: these numbers dont matter?

        text = """
        {{ !simManager.getInfoFlowDSL_closeup(selected_node) }}
        """
        # initialize the view
        @controller.makeItGo(text, closeup_paper, false)
    </script>

</body>
