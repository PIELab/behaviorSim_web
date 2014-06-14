% include('tpl/pageBits/header')

<body>
	<p class="textBox">
	    Let's start by <b>think</b>ing up an experiment. This can be a real-world experiment or an experiment which has not yet been performed. Later on we can compare simulation data with real-world results or we can use our simulation to predict the outcome of an experiment.
	</p>

    <p class="textBox">
        We think the modeling process is best thought through “one time scale at a time”. Once we have created a model considering what happens at the minute-to-minute time scale (for instance) and a separate model at the day-to-day time scale, these separate models may be able to be combined. However, it is a difficult and non-intuitive process to think about multiple effects at multiple time-scales, so we treat them one at a time.
    </p>

    <p class="textBox">
        Here the "time scale" of a model is described by the optimal range of time your model should simulate over, or by the amount of time that passes in one "cycle" of the model. For instance: if you are considering how self-efficacy changes over time and how this influences levels of physical activity throughout the day, we would call this a "day scale" model. More examples are shown in the following table.
    </p>
    <table border="1" >
        <tr>
            <td><b>level</b></td>
            <td><b>example</b></td>
        </tr>
        <tr>
            <td>instantaneous aka momentary aka in-the-moment</td>
            <td><a href="http://www.behaviormodel.org/">BJ Fogg's motivation-ability-trigger model</a></td>
        </tr>
        <tr>
            <td>day</td>
            <td>Circadian rhythm model describing amount of energy at each hour of the day.</td>
        </tr>
        <tr>
            <td>week</td>
            <td>Work-week model describing amount of hours worked per day on weekends and weekdays.</td>
        </tr>
        <tr>
            <td>seasonal</td>
            <td>a description of how Seasonal Affect Disorder impacts reported levels of happiness over various seasons of the year.</td>
        </tr>
    </table>

    <p>
        There is no formula to tell you what time scale your model should use, but if you are unsure it may help to imagine looking at how the variables in your model change over time on a time series graph, and then identify the size (in time) of interesting features. Let's talk about sleep: "Alice's model of sleep" (not a real model) says that everyone always sleeps between the hours of 23:00-7:00. Now let's look at some graphs:
    </p>

    <pre>
        ### one day ###
        awake                 --------------------------------
        asleep ---------------                                --------
         (hr)  00            07                               23     24

        ### three days ###
        awake     -------     -------     -------
        asleep ---       -----       -----       --

        ### 1 month ###
        awake   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        asleep - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        ### 10 years ###
        awake  ------------------------------------------------
        asleep ------------------------------------------------
    </pre>

    <p>
        In these graphs it is clear that the model is cyclic, and has a period of 1 day. Notice how looking at 1 day is interesting, looking at 3 days or more is a bit redundant because the pattern repeats, and at the 10-year level details are indiscernible. This tells us that this is probably best described as a day-scale model.
    </p>
    <p>
        Got all that? If you're confused, just let us know using the feedback button and we'll do our best to improve things. So what is the time scale of your model?
    </p>

    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.min.css">

    <select id="time-scales" data-placeholder="Choose Your Time Scale" class="chosen-select" multiple style="width:250px;" tabindex="4">
        <option value=""></option>
            % for ts in time_scales:
        <option value="{{ts}}">{{ts}}</option>
            % end
    </select>

    <!-- TODO: add data post to server (see think/csmb for similar code -->

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

	<br>

	you can: <br>
	<a href="/think/CSMB" class="myButton">List Your Variables</a>
	<a href="#" class="disabledButton" >Load an Experiment from File</a>
	<a href="#" class="disabledButton">Use a Behavior Change Ontology</a>

	%include('tpl/pageBits/nav')
</body>
