class Study
    # a basic study object which displays instructions, records data, and listens for study completion
    # :requires: jquery
    constructor: (options)->
        @options = options
        
    completeStudy: ()=>
        @options.studyTextElement.html(@options.finishedHTML);

    startStudy: ()->
        @options.studyTextElement.html(@options.introHTML);
        $(document).on(@options.studyCompleteEvent, @completeStudy)

try
    window.Study = Study
catch error
    module.exports = Study