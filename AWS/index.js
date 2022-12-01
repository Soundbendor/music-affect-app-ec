'use strict';
console.log('Loading function');
const { processResponse } = require('./add_data');
const { readAllSongs, readAllResponses, readAllResponsesOld }  = require('./read_data');
exports.handler = async (event) => {
    
    let responseCode = 200;
    let response_body = ""
    console.log("request: " + JSON.stringify(event));
    
    // this is not exactly how this will work, this is temporary for easy testing...
    
    // read data
    if(event.httpMethod == "GET") {
        console.log("GET");
        let res = await readAllResponses()
        console.log("Retrieved data");
        console.log(res);
        response_body = res;
        
    // submit app data
    } else if (event.httpMethod == "POST") {
        console.log("POST");
        // get all client user response data from request body
        let app_data = event.body;
        
        // break into affect data, song data, user data
        let affect_data = app_data.affect_data;
        let song_data = app_data.song_data;
        let user_data = app_data.user_data;
        
        let res = await processResponse(affect_data, song_data, user_data)
        console.log("Logged app data")
        console.log(res);
        
        response_body = "Success (?)"

    } else {
        console.log("No HTTP method specified")
    }
    
    // The output from a Lambda proxy integration must be 
    // in the following JSON object. The 'headers' property 
    // is for custom response headers in addition to standard 
    // ones. The 'body' property  must be a JSON string. For 
    // base64-encoded payload, you must also set the 'isBase64Encoded'
    // property to 'true'.
    let response = {
        statusCode: responseCode,
        headers: {
            "x-custom-header" : "example-header"
        },
        body: JSON.stringify(response_body)
    };
    console.log("response: " + JSON.stringify(response))
    return response;
};