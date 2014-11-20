class Study
    # a basic study object which displays instructions, records data, and listens for study completion
    # :requires: jquery, dust.js
    # :options:
    #   studyId: string which identifies the study (for data logging purposes)
    #   target: url to which the form will be POSTed
    #   completionRedirect: url which users are sent to after the form data is submitted
    #   studyTextElement: jquery selection for the text element where study intro/completion html gets inserted
    #   introHTML: html or text to insert into the studyTextElement on studyStart
    #   finishedHTML: html or text to insert into the studyTextElement on studyComplete
    #
    #   # TODO: these two are redundant???:
    #   submitBtnElement: jquery selection for the submit button
    #   submitBtnId: id text of the submit-study-data button
    #
    #   studyCompleteEvent: name of the jquery custom event which signals study completion
    #   # TODO: add studySubmit event (btn triggers event, then it is recieved); remove submitBtnId/Elment
    #
    #   formTemplate: name of the dust.js template to use to build the form (should NOT contain <form></form> wrapper)
    #   getFormTemplateValues: function which returns the template key/val list object for dust.js

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
        $(document).on('click', @options.submitBtnId, @submitStudy);  # activate study completeBtn

    submitStudy: ()=>
        # triggered by clicking on the "submit study" button, this gets all data from the 
        # the given options javascript, POSTs it to options.target, and redirects to options.debriefPage
        
        #TODO: get form HTML with values filled by javascript in options.???
        # (most easily done using dust.js)
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