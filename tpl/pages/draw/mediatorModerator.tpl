% include ('tpl/pageBits/header')

<head>
    <!-- tooltipster (for on-hover help texts & images) -->
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/tooltipster/3.0.5/css/themes/tooltipster-light.min.css" />

    <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.0.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/tooltipster/3.0.5/js/jquery.tooltipster.min.js"></script>

    <script>
        $('#direct-connect').tooltipster({
            content: $('blargyblarrgblarg'),
            // setting a same value to minWidth and maxWidth will result in a fixed width
            minWidth: 300,
            maxWidth: 300,
            position: 'right'
        });
        $('#moderate-connect').tooltipster({
            content: $('<img src="http://i.imgur.com/SDPz74E.gif" width="50" height="50" /><p style="text-align:left;"><strong>Soufflé chocolate cake powder.</strong> Applicake lollipop oat cake gingerbread.</p>'),
            // setting a same value to minWidth and maxWidth will result in a fixed width
            minWidth: 300,
            maxWidth: 300,
            position: 'right'
        });
        $('#mediate-connect').tooltipster({
            content: $('<img src="http://i.imgur.com/SDPz74E.gif" width="50" height="50" /><p style="text-align:left;"><strong>Soufflé chocolate cake powder.</strong> Applicake lollipop oat cake gingerbread.</p>'),
            // setting a same value to minWidth and maxWidth will result in a fixed width
            minWidth: 300,
            maxWidth: 300,
            position: 'right'
        });

        $(document).ready(function() {
            $('.tooltip').tooltipster();
        });
    </script>
</head>

<body>

    <div class="wrap">
        <p>
            We've added all your variables as nodes, but we need to draw arrows (edges) to show how they are connected.
            Variables can depend on each other in several different ways, and we must show those here. Your options are:
            <ol>
                <li><span id="direct-connect" class="tooltipstered">direct : variable is linearly dependent on another. </span></li>
                <li id="moderate-connect" class="tooltipstered" onclick="console.log('test')">moderator : variable affects direction or strength of relation between independent & dependent vars.</li>
                <li><div id="mediate" class="tooltip" title="message">mediator : variable which acts in between two vars to explain apparent relationship.</div></li>
            </ol>
            Hover over to see an example.
        </p>
    </div>
    <br>
    
    <div id='infoFlow'>

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

        <div class="wrap">
            <div class="left-column">
                <div class="title" style="overflow:hidden">Code your diagram here
                    <button class="btn btn-primary btn-mini" id="diagramophone" style="float: right">GO</button>
                </div>
                <textarea style="width:390px" id="textarea" rows="17"></textarea>

                <br/>
                <div class="title">Sub-models</div>
                <select id="submodel_selector" data-placeholder="select submodel..." class="chosen-select" style="width:250px;" tabindex="4">
                    <option value="None">(more coming soon)</option>
                </select>
                <button class="btn btn-primary btn-mini" id="submodel_inserter">Insert Selected Sub-model</button>

                <div class="title">How do I use this?</div>
                <div class="well">
                    <p class="code comment">// lines starting with // are comments</p>
                    <p class="code">// say whatever you want in them</p>
                    <p class="code comment">// connect nodes together using arrows </p>
                    <p class="code">a -&gt; b</p>
                    <p class="code comment">// connect moderators using named links</p>
                    <p class="code">a -&gt; b : connectionName</p>
                    <p class="code">c -&gt; connectionName</p>
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

            <div class="right-column">
                <div class="title" style="overflow:hidden">Information Flow Diagram of your model &nbsp;&nbsp;&nbsp;&nbsp;
                    <button class="btn btn-primary btn-mini" id="saveIt">SAVE IT</button>
                </div>
                <div id="canvas"> </div>
            </div>
        </div>
        <script type="text/coffeescript">

### all this is diagramophone controls that I don't yet fully understand ###

@controller = new Controller

paper = Raphael "canvas", 400, 400

sampleText = """
{{ !simManager.getInfoFlowDSL() }}
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
</script>

    </div>
    
    <br>
    
    <a href="/specify" class="myButton">Done</a>

	%include('tpl/pageBits/nav')
</body>
