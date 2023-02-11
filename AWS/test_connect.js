const { readAllResponses, readResponsesOfSong, misc } = require('./read_data');
const { processResponse } = require('./add_data');

//Example of using the readAllResponses function
function thing1(){
    readAllResponses()
        .then(returnVal => {
            console.log(returnVal);
        });
}

//Example of using the processResponse function
function thing2(){
    let exampleSong = {song_id: 4, title: "FIGHT THE POWER", artist: "FIGHT", genre: "THE", seconds: 432}
    let exampleUser = {user_id: 2, location: "Unova"};
    let exampleData = {grandma: "POWER", valance: [1, 6, 3, 5], arousal: [8, 4, -2, 4]};

    processResponse(exampleData, exampleSong, exampleUser)
        .then(res => {
            console.log("YOU'VE REACHED THE OUTPUT!")
            console.log(res);
        });
}

misc.readResponsesOfGenre("Dubstep")
    .then(returnVal => {
        console.log(returnVal);
    });