'use strict';
console.log('Loading function');
const { processResponse } = require('./add_data');
const { readAllResponses }  = require('./read_data');
const { deleteUser, deleteSong, deleteResponse } = require('./delete_data');
exports.handler = async (event) => {
    
    let statusCode = 200;
    let response_body = "";
    console.log("request: " + (JSON.stringify(event)));
    
    // read data
    if(event.httpMethod == "GET") {

        console.log("GET");
        let res = await readAllResponses();
        console.log("Retrieved data");
        console.log(res);
        response_body = res;
        
    // submit app data
    } else if (event.httpMethod == "POST") {
        console.log("POST");
        const body = JSON.parse(event.body);
        console.log(body);
        
        // get all client user response data from request body
        const { user_data, song_data, affect_data } = body;
        console.log(song_data);

        try {
            // see if database logs response properly
            let res = await processResponse(affect_data, user_data, song_data)

            console.log("Logged app data");
            console.log(res);
            response_body = "Successfully recorded affect response data";

        } catch (err) {
            // catch validation errors
            statusCode = 400;
            console.log(err)
            response_body = "Validation error"
        }
    
    // delete user data
    } else if (event.httpMethod == "DELETE") {
        const body = JSON.parse(event.body);

        try {
            switch (body.table) {
                case "users":
                    await deleteUser(body.user_id);
                    response_body = "Successfully deleted user profile";
                    break;
                case "songs":
                    await deleteSong(body.song_uri);
                    response_body = "Successfully deleted song";
                    break;
                case "responses":
                    await deleteResponse(body.user_id, body.song_uri);
                    response_body = "Successfully deleted response";
                    break;
                default:
                    response_body = `Unknown table specified: ${body.table}`;
            }
        } catch (err) {
            statusCode = 400;
            console.log(err);
            response_body = "Error in deletion";
        }

    } else {
        console.log("No HTTP method specified");
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
    console.log("response: " + JSON.stringify(response));
    return response;
};