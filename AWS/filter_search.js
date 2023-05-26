/* This is a dedicated program to search for responses in the database. To use it, set the
search_options object appropriately (or leave it empty) and run "node filter_search.js" from
the command line (without quotation marks). Read the comments below for more documentation.*/

const { filterSearch } = require("./read_data");

/*Edit this object to change the search options. The arrays below show what properties are available.
You may leave the object empty to return all responses in the database.*/
let search_options = {

};

//Here is an example object to show how you might use the various search options.
const example_search_options = {
    title: "I'd Rather Be Me",
    ad_played: false,
    age_min: 18,
    age_max: 30,
    showArrays: false,
    orderBy: "song_uri",
    sortDirection: "asc",
};

//DO NOT MODIFY any of the code written below. Only the search_options object may be modified.

/*You can set any of these properties to a value, and the search will return only responses
with a matching value for that property. For example, setting artist: "Taylor Swift",
gender: "male" will return only responses to songs by Taylor Swift from users who are male.*/
const select_options = [
    "heard_song_before", "heard_artist_before", "ad_played", "gender", "location",
    "primary_language", "listening_habits", "music_experience", "hearing_loss", "song_uri",
    "title", "artist", "album"
];

/*You can set these properties to get responses that fall between (inclusive) the min and max.
For example, setting age_min: 18, age_max: 30 will return responses from users that are 18-30
years old. If you want an exact age, you can set both min and max to the same age.*/
const range_options = [
    "date_recorded_min", "date_recorded_max",
    "age_min", "age_max"
];

/*These options are all unique, but mostly cosmetic. showArrays can be set to false to avoid
returning the valence/arousal/time_sampled arrays, which can be very large and make other info
harder to read. orderBy can be set to any database property, such as age, gender, song_uri, or
date_recorded. If orderBy is set, then setting sortDirection determines whether the responses
are sorted in ascending or descending order, by setting sortDirection: asc or sortDirection: desc.
If sortDirection isn't specified, it defaults to ascending.*/
const display_options = ["showArrays", "orderBy", "sortDirection"];

filterSearch(search_options)
    .then(response => {
        console.log("Performing filtered search with the following search conditions:");
        console.log(search_options);
        console.log("To modify the search conditions, edit the search_options object in the file 'filter_search.js'.");
        console.log("Here are the search results:");
        console.log(response);
    })
