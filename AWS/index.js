'use strict';
console.log('Loading function');
const { processResponse } = require('./add_data');
const { readAllResponses }  = require('./read_data');
exports.handler = async (event) => {
    
    let statusCode = 200;
    let response_body = ""
    console.log("request: " + JSON.stringify(event));
    
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
        const { body } = event;
        const { affect_data, song_data, user_data } = body;

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
    const response = {
        statusCode,
        headers: {},
        body: JSON.stringify(response_body)
    };
    console.log("response: " + JSON.stringify(response))
    return response;
};