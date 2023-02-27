const { readAllResponses, readResponsesOfSong, misc } = require('./read_data');
const { processResponse, processResponse2 } = require('./add_data');

//Example of using the readAllResponses function
function thing1(){
    readAllResponses()
        .then(returnVal => {
            console.log(returnVal);
        });
}

//Example of using the processResponse function
function thing2(){
    let exampleSong = {song_uri: "blahblahBLAH", title: "Fighting Dreamers", artist: "FIGHTing", album: "Naruto", seconds: 432}
    let exampleUser = {user_id: 4, location: "DREAMers"};
    let exampleData = {valance: [1.1, 6.2, 3, 5], arousal: [8, 4, -2, 4], time_sampled: [1, 2, 3, 4]};

    processResponse(exampleData, exampleUser, exampleSong)
        .then(res => {
            console.log(res);
        });
}

//thing2();
thing1();

/*readAllResponses()
    .then(returnVal => {
        console.log(returnVal);
    });*/