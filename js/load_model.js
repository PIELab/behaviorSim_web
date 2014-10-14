// file upload validation
$(':file').change(function(){
    var file = this.files[0];
    var name = file.name;
    var size = file.size;
    var type = file.type;
    console.log(file);
    //Your validation
    
    // process the file
    if (file) {
        var reader = new FileReader();
        reader.readAsText(file, "UTF-8");
        reader.onload = function (evt) {
            //document.getElementById("fileContents").innerHTML = evt.target.result;
            var newModel = JSON.parse(evt.target.result);
            model_builder.set_model(newModel);
        } 
        reader.onerror = function (evt) {
            //document.getElementById("fileContents").innerHTML = "error reading file";
            console.log('error reading file');
            $('#model-loader').append('error reading file');
        }
    }
});