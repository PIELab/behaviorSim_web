
### this is the model inserter button ###
insertbutton = document.getElementById("submodel_inserter")
modelselector= document.getElementById("submodel_selector")

$listen submodel_inserter, 'click', =>
    switch submodel_selector.value
        when 'TPB'
            text ='\n behavioral attitude -> intention \n subjective norms -> intention \n perceived behavioral control -> intention \n perceived behavioral control -> behavior \n intention -> behavior \n'
        when 'selfEfficacy'
            text = "\n VerbalPersuasion -> SelfEfficacy \n VicariousExperience -> SelfEfficacy \n SelfEfficacy -> PhysicalActivityLevel"
        else
            console.log('unrecognized submodel value "'+submodel_selector.value+'"')
            return

    textarea.value += text
    $(document).trigger("graphChange")