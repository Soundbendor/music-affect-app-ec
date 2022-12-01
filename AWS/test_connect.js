const { readAllResponses } = require('./read_data');
const { processResponse } = require('./add_data');

//Example of using the readAllResponses function
function thing1(){
    readAllResponses()
        .then(returnVal => {
            console.log(returnVal);
            console.log(returnVal[3].user_id);
        });
}

//Example of using the processResponse function
function thing2(){
    let exampleSong = {song_id: 2, title: "Black and Orange", artist: "spongebob", genre: "blues", seconds: 432}
    let exampleUser = {user_id: 2, location: "Canada"};
    let exampleData = {grandma: "ultra Granny", valance: [1, 6, 3, 5], arousal: [8, 4, -2, 4]};

    processResponse(exampleData, exampleSong, exampleUser)
        .then(res => {
            console.log("YOU'VE REACHED THE OUTPUT!")
            console.log(res);
        });
}