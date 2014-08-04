% include ('tpl/pageBits/header')

%
% if selected_node is None:
%   redirect('/done')
% end

<body>

    <meta charset="utf-8">
    <title>behaviorSim model specification</title>
    <meta name="description" content="behavioral modeling for all">
    <meta name="author" content="USF PIE Lab">
    
    <!-- chosen -->
    <link rel="stylesheet" href="{{CONFIG.CHOSEN_CSS_URL}}">
	
	<!-- rickshaw for charts -->
    <link type="text/css" rel="stylesheet" href="/css/rickshaw/detail.css">
	<script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.9/d3.min.js"></script> 
    <script src="/js/lib/d3.layout.min.js"></script> 
    <script src="//cdnjs.cloudflare.com/ajax/libs/rickshaw/1.4.6/rickshaw.min.js"></script>

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
            <script type='text/coffeescript' src="/tpl/js/source_spec_page_controller.coffee"></script>
        % elif node_type == 'construct':
			<div class='row'>
				Example inflow time series:
				% for parent in selected_node.parents:
					<div class='col-md-2'>
						<strong>{{parent.name}}</strong>
						<div class='inflow_graph' id='{{parent.name}}_graph'></div>
						<script type='text/javascript'>
							TIME_LENGTH = 20;
							var {{parent.name}}_data = [];
							// insert initial data
							for (var i = 0; i < TIME_LENGTH; i++) {
								{{parent.name}}_data.push({x: i, y: Math.random()});
							}
							var {{parent.name}}_graph = new Rickshaw.Graph( {
								element: document.querySelector("#{{parent.name}}_graph"),
								renderer: 'area',
								stroke: true,
								width: 269,
								height: 134,
								series: [{
									name: '{{parent.name}}',
									color: 'steelblue',
									data: {{parent.name}}_data
								}]
							});

							var {{parent.name}}_hoverDetail = new Rickshaw.Graph.HoverDetail( {
								graph: {{parent.name}}_graph,
							} );

							{{parent.name}}_graph.render();

						</script>
					</div>
				% end
			</div>
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
						resulting waveform (based on given inflow conditions)
					    <div id='{{selected_node.name}}_graph'></div>
						<script type='text/javascript'>
							TIME_LENGTH = 20;
							var {{selected_node.name}}_data = [];
							// insert initial data
							for (var i = 0; i < TIME_LENGTH; i++) {
								{{selected_node.name}}_data.push({x: i, y: Math.random()});
							}
							var {{selected_node.name}}_graph = new Rickshaw.Graph( {
								element: document.querySelector("#{{selected_node.name}}_graph"),
								renderer: 'area',
								stroke: true,
								width: 600,
								height: 200,
								series: [{
									name: '{{selected_node.name}}',
									color: 'green',
									data: {{selected_node.name}}_data
								}]
							});

							var {{selected_node.name}}_hoverDetail = new Rickshaw.Graph.HoverDetail( {
								graph: {{selected_node.name}}_graph,
							} );

							{{selected_node.name}}_graph.render();

						</script>
						
						
                    </div>
                </div>
            </div>
            <script type='text/coffeescript' src="/tpl/js/model_spec_page_controller.coffee"></script>
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
