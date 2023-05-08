const { readAllResponses, filterSearch } = require('./read_data');
const { processResponse } = require('./add_data');
const { deleteUser, deleteSong, deleteResponse } = require('./delete_data');

const exampleSong = {
    song_uri: "Fake URI",
    title: "Example Title IV",
    artist: "Fake Artist",
    album: "Temp Album",
    seconds: 192,
}
const exampleUser = {
    user_id: 488,
    age: 25,
    gender: "nonbinary",
    location: "Test #6",
    primary_language: "British",
    listening_habits: "Every day",
    music_experience: null,
    hearing_loss: false,
};
const exampleData = {
    valence: [1.1, 6.2, 3, 5],
    arousal: [8, 4, -2, 4],
    time_sampled: [1, 2, 3, 4],
    heard_song_before: true,
    heard_artist_before: true,
    ad_played: false,
};

//Example of using the readAllResponses function
function readThing(){
    /*let searchOptions = {
        artist: "Stephen Schwartz",
        orderBy: "title",
        sortDirection: "asc",
        showArrays: false,
    }*/

    searchOptions = {
        showArrays: false,
        gender: "nonbinary",
    };

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

function deleteThing(){
    deleteResponse(exampleUser.user_id, exampleSong.song_uri);
}

//addThing();
readThing();
//deleteThing();

/*readAllResponses()
    .then(returnVal => {
        console.log(returnVal);
    });
//*/