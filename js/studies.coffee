# This file contains the options passed to the researchStudy.Study class in various studies,
# and also contains functions which select and setup a study based on the URI search 
# read from window.uri_search

# =====================================================================================
#                               options for the various studies
# =====================================================================================
minimal_example = {
    studyTextElement: $("#study-text"),
    introHTML: "Welcome to the study!",
    studyCompleteEvent: "modelComplete",
    finishedHTML: "Complete the study by clicking here",
    studyId: "DEMO"
}

model_builder_usability_study = {
    studyTextElement: $("#study-text"),
    introHTML: "Welcome to the study!",  # TODO: use a dust template
    studyCompleteEvent: "modelComplete",
    finishedHTML: "Complete the study by clicking here",  # TODO: use a dust template
    studyId: "U1"
}

setupStudy = ()->
    switch uri_search.SID
        when model_builder_usability_study.studyId
            optns = model_builder_usability_study
        when minimal_example.studyId
            optns = minimal_example
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