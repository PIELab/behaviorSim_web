class Study
    # a basic study object which displays instructions, records data, and listens for study completion
    # :requires: jquery
    constructor: (options)->
        @options = options
        
    startStudy: ()->
        # inits the study, setting up the completion listener and the study instructions text
        @options.studyTextElement.html(@options.introHTML);
        $(document).on(@options.studyCompleteEvent, @completeStudy)

    completeStudy: ()=>
        # triggered when the required tasks have been completed. The finishedHTML is shown.
        # The button or link to finish and submit the data (given by @options.submitBtnElement)
        @options.studyTextElement.html(@options.finishedHTML);
        @options.submitBtnElement.on("click", @submitStudy)
        
    submitStudy: ()=>
        # triggered by clicking on the "submit study" button, this gets all data from the 
        # the given options javascript, POSTs it to options.target, and redirects to options.debriefPage
        
        #TODO: get form HTML with values filled by javascript in options.???
        # (most easily done using dust.js)
        dust.render(@options.formTemplate,
            @options.formTemplateValues,
            (err, out) =>
                # update the html
                $('#modeling-options-form').append(out)
                @_init_slider_and_box(name, val)
                if err
                    console.log(err))

try
    window.Study = Study
catch error
    module.exports = Study