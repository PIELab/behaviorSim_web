# This file contains the options passed to the researchStudy.Study class in various studies,
# and also contains functions which select and setup a study based on the URI search 
# read from window.uri_search

# =====================================================================================
#                               options for the various studies
# =====================================================================================
# "study" which records data from people "demoing" the app
app_demo = {
    studyId: "DEMO",
    target: "#",
    completionRedirect: "#",
    studyTextElement: $("#study-text"),
    introHTML: "Welcome to the demo!",
    finishedHTML: "Finish the demo by clicking here",
    studyCompleteEvent: "",
    studySubmitEvent: "",
    formTemplate: "sample_form"  # form dust template (should contain only input elements, not the encapsulating form element)
    getFormTemplateValues: () ->   # params to pass into form
        return {}
}

# user study for the model builder
model_builder_usability_study = {
    studyTextElement: $("#study-text"),
    # TODO: use a dust template for introHTML?
    introHTML: """
                <div class='box box-primary' id='study-intro-box'>
                    <div class='box-header'>
                        Modeling Task Instructions
                    </div>
                    <div class="row">
                        <div class="col-xs-6">
                            <div id='study-intro-intro' class="box box-primary">
                                Your goal in this activity is to create a model based on Icek Ajzen's Theory of Planned Beahvior (TPB) as it applies to physical activity. From this model we will be able to perform simulations and see how a simulation agent with the TPB at its core might behave in various scenarios.
                            </div>
                        </div>
                        <div class="col-xs-6">

                            <div id="tpb-description" class="box box-primary col-xs-6">
                                <div class='box-header'>
                                    Theory of Planned Behavior Summary
                                </div>
                                <a href="http://en.wikipedia.org/wiki/Theory_of_planned_behavior">The Theory of Planned Beahvior</a> (TPB) states that attitude toward behavior, subjective norms, and perceived behavioral control, together shape an individual's behavioral intentions and behaviors. "Intentions to perform behaviors of different kinds can be predicted with high accuracy from attitudes toward the behavior, subjective norms, and perceived behavioral control; and these intentions, together with perceptions of behavioral control, account for considerable variance in actual behavior. Attitudes, subjective norms, and perceived behavioral control are shown to be related to appropriate sets of salient behavioral, normative, and control beliefs about the behavior, but the exact nature of these relations is still uncertain. <a href="http://dx.doi.org/10.1016%2F0749-5978%2891%2990020-T">(Ajzen 1985)</a>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="todo-checklist" class="box box-primary">
                                Task completion checklist:
                                <ol>
                                    <li>Create "information-flow" diagram of the TPB
                                        <ul>
                                            <li>generic example has been included to help</li>
                                            <li>use text box on left to change the diagram</li>
                                            <li>develop a path diagram of the TPB</li>
                                        </ul>
                                    </li>
                                    <li>Describe relations between variables
                                        <ul>
                                            <li>click each node in the diagram to select it</li>
                                            <li>use the "Selected Node Model Specification" widget to formulate the variable in terms of its inflows.</li>
                                            <li>define inputs for nodes with no inflows</li>
                                            <li>use the "mini-simulation" widgets to see how values change over time.</li>
                                        </ul>
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
            """,

    studyCompleteEvent: "modelComplete",
    studySubmitEvent: "submitTheStudy",
    finishedHTML: "Your model looks complete, nice work! When you are ready, <a href='#' onclick='$(document).trigger(\"submitTheStudy\")'>click here to submit your model and finish.</a>",  # TODO: use a dust template?
    studyId: "U1",
    target:"https://docs.google.com/a/mail.usf.edu/forms/d/18qPcVfTXrsiF8ZgEWe_5qgpDrgncges80j8-7Ys3Zsk/formResponse",  # place where data POSTs to
    completionRedirect: "modelBuilderUsabilityStudy/usabilitySurvey.html",  # where to send participants after completing study & submitting data
    getFormTemplateValues: () ->
        vals = {PID: uri_search.PID}
        vals.DSL = $("#textarea").val()
        vals.Model = simulator._model  # uses dust json parser {thing|js}
        vals.UserAgent = navigator.userAgent
        return vals
    formTemplate: "model_builder_usability"  # form dust template (should contain only input elements, not the encapsulating form element)
}

setupStudy = ()->
    switch uri_search.SID
        when model_builder_usability_study.studyId
            optns = model_builder_usability_study
        when app_demo.studyId
            optns = app_demo
        when "", undefined, null 
            return  # no study
        else
            console.log("study Id from uri_search: ", uri_search.SID)
            throw Error("unknown studyId")

    # try to set pid
    optns.participantId = uri_search.PID

    window.study = new Study(optns)
    study.startStudy()

setupStudy()