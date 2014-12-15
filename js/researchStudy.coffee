class Study
    # a basic study object which displays instructions, records data, and listens for study completion
    # :requires: jquery, dust.js
    # :options:
    #   studyId: string which identifies the study (for data logging purposes)
    #
    #   target: url to which the form will be POSTed
    #   completionRedirect: url which users are sent to after the form data is submitted
    #
    #   studyTextElement: jquery selection for the text element where study intro/completion html gets inserted
    #   introHTML: html or text to insert into the studyTextElement on studyStart
    #   finishedHTML: html or text to insert into the studyTextElement on studyComplete
    #
    #   studyCompleteEvent: name of the jquery custom event which signals study completion
    #   studySubmitEvent: name of the jquery custom event which triggers submission of study data
    #        (e.g.: a btn triggers this event and it is recieved by the Study obj automatically)
    #
    #   formTemplate: name of the dust.js template for the form (should NOT contain <form></form> wrapper)
    #   getFormTemplateValues: function which returns the template key/val list object for dust.js

    constructor: (options)->
        @options = options
        @completed = false
        
    startStudy: ()->
        # inits the study, setting up the completion listener and the study instructions text
        @options.studyTextElement.html(@options.introHTML);
        $(document).on(@options.studyCompleteEvent, @completeStudy)

    completeStudy: ()=>
        # triggered when the required tasks have been completed. The finishedHTML is shown.
        # The button or link to finish and submit the data (given by @options.submitBtnElement)
        if !@completed
            @options.studyTextElement.append(@options.finishedHTML);
            $(document).on(@options.studySubmitEvent, @submitStudy);  # activate study completeBtn
            @completed=true

    submitStudy: ()=>
        # triggered by clicking on the "submit study" button, this gets all data from the 
        # the given options javascript, POSTs it to options.target, and redirects to options.debriefPage
        
        # get form HTML with values filled by javascript in @options
        dust.render(@options.formTemplate,
            @options.getFormTemplateValues(),
            (err, out) =>
                window.studySubmitted = false
                # update the html
                pre = '<div class="ss-form" style="display:none;"><iframe id="submit_frame" name="submit_frame" onload="if(studySubmitted) {window.location=\'' + @options.completionRedirect + '\';}"></iframe><form id="ss-form" method="POST" action="' + @options.target + '" target="submit_frame">'
                post = "</form></div>"
                $('body').append(pre + out + post)
                # submit data
                document.getElementById("ss-form").submit();
                # redirect
                window.studySubmitted = true
                #window.location = @options.completionRedirect
                if err
                    console.log(err))

try
    window.Study = Study
catch error
    module.exports = Study