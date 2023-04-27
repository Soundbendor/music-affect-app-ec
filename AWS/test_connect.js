const { readAllResponses, filterSearch } = require('./read_data');
const { processResponse } = require('./add_data');

const exampleSong = {song_uri: "Fake URI", title: "Example Title IV", artist: "Fake Artist", album: "Temp Album", seconds: 192}
const exampleUser = {user_id: 481, gender: "nonbinary", location: "Test #5"};
const exampleData = {valence: [1.1, 6.2, 3, 5], arousal: [8, 4, -2, 4], time_sampled: [1, 2, 3, 4]};

//Example of using the readAllResponses function
function readThing(){
    /*let searchOptions = {
        artist: "Stephen Schwartz",
        orderBy: "title",
        sortDirection: "asc",
        showArrays: false,
    }*/

    searchOptions = { gender: "nonbinary"};

    filterSearch(searchOptions)
        .then(returnVal => {
            console.log(returnVal);
        });
}

//Example of using the processResponse function
function addThing(){
    
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
    });
//*/