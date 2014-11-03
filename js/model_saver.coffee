# hide the model saver until model is complete
$("#model-saver").hide()

`function make_download_json_btn() {
    // downloads the json file
    var data = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(simulator._model));
    $('#download-button').html('<a href="data:' + data + '" download="data.json">download JSON</a>');
}`

make_save_model_box = () ->
    # set up the download button (needs to be done after each change in model)
    make_download_json_btn()
    # TODO: show this box when model is completed
    $("#model-saver").show()

$(document).on("modelComplete", (evt) -> make_save_model_box())