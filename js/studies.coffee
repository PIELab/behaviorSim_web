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
    introHTML: "Welcome to the study!",
    finishedHTML: "Complete the study by clicking here",
    studyCompleteEvent: "",
    studySubmitEvent: "",
    formTemplate: "sample_form"  # form dust template (should contain only input elements, not the encapsulating form element)
    getFormTemplateValues: () ->   # params to pass into form
        return {}
}

# user study for the model builder
model_builder_usability_study = {
    studyTextElement: $("#study-text"),
    introHTML: "Please attempt to re-create the model described below: <br> <br> The Theory of Planned Beahvior (TPB) states that attitude toward behavior, subjective norms, and perceived behavioral control, together shape an individual's behavioral intentions and behaviors.",  # TODO: use a dust template?
    studyCompleteEvent: "modelComplete",
    studySubmitEvent: "submitTheStudy",
    finishedHTML: "Your model looks complete, nice work! When you are ready, <a href='#' onclick='$(document).trigger(\"submitTheStudy\")'>click here to submit your model and finish.</a>",  # TODO: use a dust template?
    studyId: "U1",
    target:"https://docs.google.com/a/mail.usf.edu/forms/d/18qPcVfTXrsiF8ZgEWe_5qgpDrgncges80j8-7Ys3Zsk/formResponse",  # place where data POSTs to
    completionRedirect: "https://docs.google.com/forms/d/1rqvpAOT96_uIo4DK-ACBp9s1cIj1gDVLZQs3QRYig0w/viewform?usp=send_form",  # where to send participants after completing study & submitting data
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