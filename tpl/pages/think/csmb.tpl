% include('tpl/pageBits/header')

  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.min.css">

<body>
	<p>
	To be able to simulate your experiment, we need to know what you are measuring.

	By thinking about your experiment from just one participant's perspective, we can separate measurements into three groups:
	<ol>
		<li> <b>contextual</b> : measurements of subject surroundings, situation, or environment. </li>
		<li> <b>behavioral</b> : measures of subject actions, reported behaviors or decisions. </li>
		<li> <b>constructs</b> : measures of the subject's internal state, feelings, or thoughts. </li>
	</ol>

	list your measures below:
	</p>

	<div>
		<div class="inline">
			<b>Context</b> <br>
			<select id="contexts" data-placeholder="Choose Context Vars..." class="chosen-select" multiple style="width:250px;" tabindex="4">
            <option value=""></option>
				% for context in contexts:
            <option value="{{context}}">{{context}}</option>
				% end
			</select>
		</div>

		<div class="inline">
			<h1>↦</h1>
		</div>

		<div class="inline">
			<b>Constructs</b> <br>
			<select id='constructs' data-placeholder="Choose Construct Vars..." class="chosen-select" multiple style="width:250px;" tabindex="4">
            <option value=""></option>
				% for construct in constructs:
            <option value="{{construct}}">{{construct}}</option>
				% end
			</select>
		</div>

		<div class="inline">
			<h1>↦</h1>
		</div>

		<div class="inline">
			<b>Behaviors</b> <br>
			<select id="behaviors" data-placeholder="Choose Behavior Vars..." class="chosen-select" multiple style="width:250px;" tabindex="4">
            <option value=""></option>
				% for behavior in behaviors:
            <option value="{{behavior}}">{{behavior}}</option>
				% end
			</select>
		</div>

	</div>

	<a href="/draw" class="myButton">Done</a>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
  <script src="//cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.jquery.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    var config = {
      '.chosen-select'           : {},
      '.chosen-select-deselect'  : {allow_single_deselect:true},
      '.chosen-select-no-single' : {disable_search_threshold:10},
      '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
      '.chosen-select-width'     : {width:"95%"}
    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }
  </script>

</body>
