'use strict';
console.log('Loading function');
const { processResponse, createUser, createSong, updateUser, updateSong } = require('./add_data');
const { readAllResponses, filterSearch }  = require('./read_data');
const { deleteUser, deleteSong, deleteResponse } = require('./delete_data');
exports.handler = async (event) => {
    
    let statusCode = 200;
    let response_body = "";
    console.log("request: " + (JSON.stringify(event)));
    
    // read data
    if(event.httpMethod == "GET") {
        let res;

        const body = event.body ? JSON.parse(event.body) : null;
        if (body != null && body.function == "search") {
            try {
                res = await filterSearch(body.searchOptions);
                console.log("Searched database");
                console.log(res);
                response_body = res;
            } catch (err) {
                statusCode = 400;
                console.log(err);
                response_body = "Error searching";
            }
        } else {
            console.log("GET");
            res = await readAllResponses();
            console.log("Retrieved data");
            console.log(res);
            response_body = res;
        }
        
    // submit app data
    } else if (event.httpMethod == "POST") {
        console.log("POST");
        const body = JSON.parse(event.body);
        console.log(body);

        // if no table specified, default to responses
        if (body.table == undefined) {
            body.table == "responses";
        }
        
        // get all client user response data from request body
        const { user_data, song_data, affect_data } = body;
        //console.log(song_data);

        try {
            let res;

            switch (body.table) {
                case "users":
                    res = await createUser(user_data);
                    console.log("Added user");
                    console.log(res);
                    response_body = "Successfully added user profile to database";
                    break;

                case "songs":
                    res = await createSong(song_data);
                    console.log("Added song");
                    console.log(res);
                    response_body = "Successfully added song to database";
                    break;

                case "responses":
                    // see if database logs response properly
                    res = await processResponse(affect_data, user_data, song_data)
        
                    console.log("Logged app data");
                    console.log(res);
                    response_body = "Successfully recorded affect response data";
                    break;
                
                default:
                    response_body = `Unknown table specified: ${body.table}`;
            }

        } catch (err) {
            // catch validation errors
            statusCode = 400;
            console.log(err)
            response_body = "Validation error"
        }
    
    // delete user data
    } else if (event.httpMethod == "PUT") {
        console.log("PUT");
        const body = JSON.parse(event.body);
        console.log(body);

        try {
            switch (body.table) {
                case "users":
                    await updateUser(body.user_data);
                    response_body = "Successfully updated user profile";
                    break;
                case "songs":
                    await updateSong(body.song_data);
                    response_body = "Successfully updated song";
                    break;
                case "responses":
                    response_body = "There's no dedicated function to update responses, use processResponse instead";
                    break;
                default:
                    response_body = `Unknown table specified: ${body.table}`;
            }
        }
        catch (err) {
            statusCode = 400;
            console.log(err);
            response_body = "Error updating data";
        }
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