// loads URI search into global uri_search var window.uri_search
uri_search = {};
if (window.location.search){
    try{
        var search = window.location.search.split('?')[1];
        var keyValPairs = search.split('&');
        for (i in keyValPairs){
            var key = keyValPairs[i].split('=')[0];
            var val = keyValPairs[i].split('=')[1];
            uri_search[key] = val;
        }
    } catch (err) {
         if (err.message == "Cannot read property 'split' of undefined"){
            console.log("ERR in URI search: ", window.location.search);
            throw Error("error parsing uri search string");
         } else {
            throw err;
        }
    }
}  // else no search string.