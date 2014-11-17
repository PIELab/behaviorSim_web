optns = {
    studyTextElement: $("#study-text"),
    introHTML: "Welcome to the study!",
    studyCompleteEvent: "modelComplete",
    finishedHTML: "Complete the study by clicking here",
    participantId: uri_search.pid,
    studyId: uri_search.studyId
}

class Study
    # a basic study object which displays instructions, records data, and listens for study completion
    # :requires: jquery, dust.js
    constructor: (options)->
        @options = options
        
    completeStudy: ()=>
        @options.studyTextElement.html(@options.finishedHTML);

    startStudy: ()->
        @options.studyTextElement.html(@options.introHTML);
        $(document).on(@options.studyCompleteEvent, @completeStudy)

study = new Study(optns)
study.startStudy()