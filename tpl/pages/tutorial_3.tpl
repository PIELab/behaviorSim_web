% include ('tpl/pageBits/header')

<body>
    
    <div id='infoFlow'>
        <meta charset="utf-8">
        <title>diagramophone</title>
        <meta name="description" content="diagrams for all">
        <meta name="author" content="Monica Dinculescu">

        <!-- prettify things (diagramophone) -->
        <!--<link href="/js/lib/diagramophone/lib/bootstrap.min.css" rel="stylesheet"> (it's already loaded)-->
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

        <div class="row">
            <div class="column col-md-12">
                <p>
                We've added all your variables as nodes, but we need to draw arrows (edges) to show how they are connected.
                Try to imagine how the information "flows" from context nodes towards the behavior nodes.
                Don't worry too much about <i>how</i> the information from a node affects its connections just yet; we'll do that next.
                Imagine that each arrow says, "depends on", and don't worry about how yet. When we do "A -> B" we are saying that B is a function of A, but we're not worrying about what that function looks like yet. So "A -> B; C -> B" tells us that "B = f(A, C)", and we'll define f later.
                </p>
            </div>
        </div>
        <div class="row">
            <div class="left-column col-md-4">
                <div class="title" style="overflow:hidden">Code your diagram here
                    <button class="btn btn-primary btn-mini" id="diagramophone" style="float: right">GO</button>
                </div>
                <textarea style="width:390px" id="textarea" rows="17"></textarea>

                <br/>
                <div class="title">Sub-models</div>
                <select id="submodel_selector" data-placeholder="select submodel..." class="chosen-select" style="width:250px;" tabindex="4">
                    <option value="TPB">Theory of Planned Behavior</option>
                </select>
                <button class="btn btn-primary btn-mini" id="submodel_inserter">Insert Selected Sub-model</button>

                <div class="title">How do I use this?</div>
                <div class="well">
                    <p class="code comment">// lines starting with // are comments</p>
                    <p class="code">// say whatever you want in them</p>
                    <p class="code comment">// connect nodes together using arrows </p>
                    <p class="code">a -&gt; b</p>
                    <p>Use the "add submodel" button to insert existing model linkages in your diagram code. </p>
                </div>

                <br/>
                <div class="title">Settings</div>
                <label class="checkbox">
                        <input type="checkbox" id="fontBtn" checked="false">use silly handwritten font
                </label>
                <label class="checkbox">
                    <input type="checkbox" id="replBtn" checked="false">live updates -- this will make things slower
                </label>
            </div>

            <div class="diagram-column col-md-8">
                <div class="title" style="overflow:hidden">Information Flow Diagram of your model &nbsp;&nbsp;&nbsp;&nbsp;
                    <button class="btn btn-primary btn-mini" id="saveIt">SAVE IT</button>
                </div>
                <div id="canvas"> </div>
            </div>
        </div>
    </div>
    
    <br>
    
    <a class="myButton" id="done-btn">Done</a>

	%include('tpl/pageBits/nav')
        
        
        <script type="text/coffeescript">

### all this is diagramophone controls that I don't yet fully understand ###

@controller = new Controller

paper = Raphael "canvas", 800, 600

sampleText = """
Verbal Persuasion -> Self Efficacy
Vicarious Experience -> Self Efficacy
Self Efficacy -> Physical Activity Level
"""

$listen = (target, name, callback) ->
	if target.addEventListener
		target.addEventListener name, callback, false
	else
		target.attachEvent "on#{name}", callback

goBtn = document.getElementById("diagramophone")
textarea = document.getElementById("textarea")
repl = document.getElementById("replBtn")
fontBtn = document.getElementById("fontBtn")
saveBtn = document.getElementById("saveIt")
raphaelCanvas = document.getElementById("canvas")

$listen goBtn, 'click', => @controller.makeItGo(textarea.value, paper, fontBtn.checked)
$listen saveBtn, 'click', => @controller.saveAllTheThings(raphaelCanvas)

$listen textarea, 'keyup', =>
	if (repl.checked)
		@controller.makeItGo(textarea.value, paper, fontBtn.checked)

$listen fontBtn, 'change', =>
	@controller.makeItGo(textarea.value, paper, fontBtn.checked)

# initialize the view
textarea.value = sampleText
@controller.makeItGo(textarea.value, paper, fontBtn.checked)

### this is the model inserter button ###
insertbutton = document.getElementById("submodel_inserter")
modelselector= document.getElementById("submodel_selector")

$listen submodel_inserter, 'click', =>
    if submodel_selector.value == 'TPB'
        textarea.value+='\n behavioral attitude -> intention \n subjective norms -> intention \n perceived behavioral control -> intention \n perceived behavioral control -> behavior \n intention -> behavior \n'
        @controller.makeItGo(textarea.value, paper, fontBtn.checked)
    else
        console.log('unrecognized submodel value "'+submodel_selector.value+'"')
        
        
### submit button ###
doneBtn = document.getElementById("done-btn")

$listen doneBtn, 'click', =>
    # post the DSL to the server    
    $.post '/draw/submit',
        DSL: textarea.value
        (data) -> window.location = '/specify'
    
</script>


<!-- tourist.js guided tour -->
<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js" type="text/javascript"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.2/backbone-min.js"></script>
<script src="/js/lib/tourist.js"></script>
<script type="text/javascript">
    var steps = [{
        content: "<p> Here is our same model graph, but we're not worrying about defining the connections and what the time-series looks like yet.</p>",
        highlightTarget: true,
        nextButton: true,
        target: $('#canvas'),
        my: 'right center',
        at: 'left center'
    },
    {
        content: '<p> Add or change the variables and connections here. <p>',
        highlightTarget: true,
        nextButton: true,
        target: $('#textarea'),
        my: 'left center',
        at: 'right center'
    },
    {
        content: '<p> When you are ready, we can move onto defining the graph "edges" (aka connections or arrows).</p>',
        highlightTarget: true,
        nextButton: true,
        target: $('#done-btn'),
        my: 'left bottom',
        at: 'right top'
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
