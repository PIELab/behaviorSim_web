/* ======================================================================
*                      useful globals
*  ====================================================================== */
/**
 * The Project ID of your Google Cloud Storage Project.
 */
var PROJECT = 'beaming-essence-764';

/**
 * Enter a client ID for a web application from the Google Developers
 * Console on the "APIs & auth", "Credentials" page. 
 * In your Developers Console project add a JavaScript origin
 * that corresponds to the domain from where you will be running the
 * script. For more info see:
 * https://developers.google.com/console/help/new/#generatingoauth2
 */
var clientId = '1032201134970-v6drnqilq0ca700pg8igcbdoeqet01c1.apps.googleusercontent.com';

/**
* Enter the API key from the Google Developers Console, by following these
* steps:
* 1) Visit https://cloud.google.com/console and select your project
* 2) Click on "APIs & auth" in the left column and then click �Credentials�
* 3) Find section "Public API Access" and use the "API key." If sample is
* being run on localhost then delete all "Referers" and save. Setting
* should display "Any referer allowed." For more info see:
* https://developers.google.com/console/help/new/#generatingdevkeys
*/
var apiKey = 'AIzaSyBDZxhITgvhyWjkmkTK-s3088_qMlfqqTo';

/**
 * To enter one or more authentication scopes, refer to the documentation
 * for the API.
 */
var scopes = 'https://www.googleapis.com/auth/devstorage.full_control';

/**
 * Constants for request parameters. Fill these values in with your custom
 * information.
 */
var API_VERSION = 'v1';

/**
 * Enter a unique bucket name to create a new bucket. The guidelines for
 * bucket naming can be found here:
 * https://developers.google.com/storage/docs/bucketnaming
 */
var BUCKET = 'user-account-info';

/**
 * The name of the object inserted via insertObject method.  
 */
var object = "";

/**
 * Get this value from the Developers Console. Click on the 
 * �Cloud Storage� service in the Left column and then select 
 * �Project Dashboard�. Use one of the Google Cloud Storage group IDs 
 * listed and combine with the prefix �group-� to get a string 
 * like the example below. 
 */
var GROUP = 
'group-0000000000000000000000000000000000000000000000000000000000000000';

/**
 * Valid values are user-userId, user-email, group-groupId, group-email,
 * allUsers, allAuthenticatedUsers
 */
var ENTITY = 'allUsers';

/**
 * Valid values are READER, OWNER
 */
var ROLE = 'READER';

/**
 * Valid values are READER, OWNER
 */
var ROLE_OBJECT = 'READER';

/* ======================================================================
*                      util functions
* ======================================================================= */
    
/**
 * Google Cloud Storage API request to insert a json object into
 * your Google Cloud Storage bucket.
 */
function insertJSONObject(fileData) {
    if (!fileData.name){
        throw Error("required property 'name' not found");
    }

    //Note: gapi.client.storage.objects.insert() can only insert
    //small objects (under 64k) so to support larger file sizes
    //we're using the generic HTTP request method gapi.client.request()
    var request = gapi.client.request({
        'path': '/upload/storage/' + API_VERSION + '/b/' + BUCKET + '/o',
        'method': 'POST',
        'params': {'uploadType': 'media', 'name': fileData.name},
        'body': fileData
    });
    
    try{
        //Execute the insert object request
        request.execute(function(resp) {
            console.log('data post resp:', resp);
        }); 
    }
    catch(e) {
        alert('An error has occurred: ' + e.message);
    }
}

/**
 * Authorize Google Cloud Storage API.
 */
function checkAuth() {
  gapi.auth.authorize({
    client_id: clientId,
    scope: scopes,
    immediate: true
  }, handleAuthResult);
}

/**
 * Handle authorization.
 */
function handleAuthResult(authResult) {
  if (authResult && !authResult.error) {
    initializeApi();
  } else {
  }
}

/**
 * Load the Google Cloud Storage API.
 */
function initializeApi() {
  gapi.client.load('storage', API_VERSION);
}

function authorize(){
    // authorizes client
    gapi.auth.authorize({
            client_id: clientId,
            scope: scopes,
            immediate: false
        }, handleAuthResult);
    return false;
}

/* ======================================================================
*                      easy API functions
* ======================================================================= */

function init_user_data_loader(){
    /**
     * Set required API keys and check authentication status.
     */
    gapi.client.setApiKey(apiKey);
    gapi.client.load('storage', API_VERSION);
    authorize();
}

function load_user_data(uid){
    // loads user data (preferences, customizations, saved things) into DOM for javascript access
    /**
     * Google Cloud Storage API request to retrieve the list of objects in
     * your Google Cloud Storage project.
     */
    try {
        var request = gapi.client.storage.objects.list({
            'bucket': BUCKET
        });
    } catch (err) {
        if (err.message == "Cannot read property 'objects' of undefined"){
            throw Error("cannot load user data before authorized");
        } else {
            throw err;
        }
    }
    request.execute(function(resp) {
        for (i in resp.items) {
            if (resp.items[i].name == uid){
                // user data found
                resp_data = resp.items[i];
                $.ajax({
                    type: "GET",
                    url: resp_data.mediaLink,
                    async: false,
                    beforeSend: function(x) {
                        if(x && x.overrideMimeType) {
                            x.overrideMimeType("application/j-son;charset=UTF-8");
                        }
                    },
                    dataType: 'json',
                    success: function(data){
                        // put package info into browser for debug n stuff
                        user_data = data;
                    }
                });
                return;
            }
        }
        // else user data not found
        console.log('Unfound UID:', uid, '\nreq. resp.:', resp)
        throw Error("user id not found");
    });
}

function save_user_data(user_data){
    // saves user data
    // :param user_data: data object to save.
    //      required properties:
    //          * name - this should be the user's UID which will be used to look up their data.
    insertJSONObject(user_data);
}