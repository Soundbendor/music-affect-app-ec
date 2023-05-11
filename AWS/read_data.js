const { PrismaClient } = require('@prisma/client')

//Returns an array containing every row in the response table + their associated user and song
module.exports.readAllResponses = async () => {
    let client = new PrismaClient();

    let retVal = await client.responses.findMany({
        select: {
            valence: true,
            arousal: true,
            time_sampled: true,
            date_recorded: true,
            heard_song_before: true,
            heard_artist_before: true,
            ad_played: true,
            users: {
                select: {
                    age: true,
                    gender: true,
                    location: true,
                    primary_language: true,
                    listening_habits: true,
                    music_experience: true,
                    hearing_loss: true,
                }
            },
            songs: true,
        },
    });

    await client.$disconnect();
    return retVal;
}

/*Returns a list of responses with their associated user and song data. Takes a searchOptions
object with several optional properties that filter and sort the results. The available
properties are:
heard_song_before, heard_artist_before, ad_played, gender, location, primary_language,
listening_habits, music_experience, hearing_loss, song_uri, title, artist, album: If these
properties are set to a value, the function will return only results where the respective
field matches that value. This is useful for finding all responses to specific song, or the
responses to a certain artist from people in a certain location.
date_recorded_min, date_recorded_max, age_min, age_max, seconds_min, seconds_max: If these
properties are set to a value, the function will return only results where the value of the
respective field is no lower or no higher than that value. This is useful for seeing
responses to songs that are 3-5 minutes long, or to see if the responses to a certain song
change significantly on/after a certain day.
orderBy and sortDirection: These are for sorting the results. orderBy can be set to any
database field, except for user_id. sortDirection can be set to "asc" or "desc" for ascending
or descending sort order. The function defaults to orderBy = "date_recorded" and
sortDirection = "asc"*/
module.exports.filterSearch = async(searchOptions) => {
    let client = new PrismaClient();

    //The showArrays property can be set to false when testing for easier viewing
    if(searchOptions.showArrays !== false){
        searchOptions.showArrays = true;
    }

    //Most searchOptions parameters are plugged directly into the query, which is used later
    let query = {
        select: {
            valence: searchOptions.showArrays,
            arousal: searchOptions.showArrays,
            time_sampled: searchOptions.showArrays,
            date_recorded: true,
            heard_song_before: true,
            heard_artist_before: true,
            ad_played: true,
            users: {
                select: {
                    age: true,
                    gender: true,
                    location: true,
                    primary_language: true,
                    listening_habits: true,
                    music_experience: true,
                    hearing_loss: true,
                }
            },
            songs: true,
        },

        where: {
            date_recorded: {
                gte: searchOptions.date_recorded_min,
                lte: searchOptions.date_recorded_max,
            },
    
            heard_song_before: searchOptions.heard_song_before,
            heard_artist_before: searchOptions.heard_artist_before,
            ad_played: searchOptions.ad_played,
    
            users: {
                age: {
                    gte: searchOptions.age_min,
                    lte: searchOptions.age_max,
                },

                gender: searchOptions.gender,
                location: searchOptions.location,
                primary_language: searchOptions.primary_language,
                listening_habits: searchOptions.listening_habits,
                music_experience: searchOptions.music_experience,
                hearing_loss: searchOptions.hearing_loss,
            },
    
            songs: {
                song_uri: searchOptions.song_uri,
                title: searchOptions.title,
                artist: searchOptions.artist,
                album: searchOptions.album,
                seconds: {
                    gte: searchOptions.seconds_min,
                    lte: searchOptions.seconds_max,
                },
            },
        },

        orderBy: {},
    };

    if(searchOptions.orderBy == undefined){
        searchOptions.orderBy = "date_recorded";
    }
    if(searchOptions.sortDirection !== "asc" && searchOptions.sortDirection !== "desc"){
        searchOptions.sortDirection = "asc";
    }

    switch(searchOptions.orderBy){
        case "song_uri":
        case "title":
        case "artist":
        case "album":
        case "seconds":
            query.orderBy.songs = {};
            query.orderBy.songs[searchOptions.orderBy] = searchOptions.sortDirection;
            break;
        
        case "age":
        case "gender":
        case "location":
        case "primary_language":
        case "listening_habits":
        case "music_experience":
        case "hearing_loss":
            query.orderBy.users = {};
            query.orderBy.users[searchOptions.orderBy] = searchOptions.sortDirection;
            break;

        default:
            query.orderBy[searchOptions.orderBy] = searchOptions.sortDirection;
    }

    let retVal = await client.responses.findMany(query);

    await client.$disconnect();
    return retVal;
}

//The three validate functions throw an error if the object doesn't have the expected properties
module.exports.validateResponse = (affectData) => {
    if(!('valence' in affectData && 'arousal' in affectData && 'time_sampled' in affectData)){
        console.log("Error: Missing arrays in affectData");
        console.log(affectData);
        throw "Missing properties in affectData.";
    }

    if(affectData.valence.length !== affectData.arousal.length ||
    affectData.arousal.length !== affectData.time_sampled.length){
        
        console.log("Error: affectData array lengths are not equal");
        console.log(affectData);
        throw "affectData array lengths are not equal.";
    }
}

module.exports.validateUser = (user) => {
    if(!('user_id' in user)){
        console.log("Error: Missing user_id in user");
        console.log(user);
        throw "Missing user_id in user.";
    }

    /*if(!('location' in user)){
        console.log("Error: Missing location in user");
        console.log(user);
        throw "Missing location in user.";
    }*/

    return true;
}

module.exports.validateSong = (song) => {
    if(!('song_uri' in song && 'title' in song && 'artist' in song &&
    'album' in song && 'seconds' in song)){
        console.log("Error: Missing properties in song");
        console.log(song);
        throw "Missing properties in song.";
    }
}

//If a user with a matching id exists, returns it. Otherwise returns false
module.exports.findUser = async (id, client) => {
    let exists = await client.users.findUnique({
        where: {
            user_id: id
        }
    })

    if(exists === null){
        return false;
    }

    return exists;
}