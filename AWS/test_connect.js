const { readAllResponses, readResponsesOfArtist, filterSearch } = require('./read_data');
const { processResponse } = require('./add_data');

//Example of using the readAllResponses function
function readThing(){
    let searchOptions = {
        artist: "Stephen Schwartz",
        orderBy: "title",
        sortDirection: "asc",
        showArrays: false,
    }
    filterSearch(searchOptions)
        .then(returnVal => {
            console.log(returnVal);
        });
}

//Example of using the processResponse function
function addThing(){
    let exampleSong = {song_uri: "TESTURI", title: "Example Title", artist: "Fake Artist", album: "Temp Album", seconds: 432}
    let exampleUser = {user_id: 4, location: "Trial City"};
    let exampleData = {valence: [1.1, 6.2, 3, 5], arousal: [8, 4, -2, 4], time_sampled: [1, 2, 3, 4]};

    processResponse(exampleData, exampleUser, exampleSong)
        .then(res => {
            console.log(res);
        });
}

//addThing();
readThing();

/*readAllResponses()
    .then(returnVal => {
        console.log(returnVal);
    });*/