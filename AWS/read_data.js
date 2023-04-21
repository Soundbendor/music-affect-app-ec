const { PrismaClient } = require('@prisma/client')

//Returns an array containing every row in the response table
module.exports.readAllResponses = async () => {
    let client = new PrismaClient();

    let retVal = await client.responses.findMany({
        select: {
            valence: true,
            arousal: true,
            time_sampled: true,
            ad_played: true,
            users: {
                select: {
                    location: true
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
ad_played, location, song_uri, title, artist, album: If these properties are set to a value,
the function will return only results where the respective field matches that value. This is
useful for finding all responses to specific song, or the responses to a certain artist from
people in a certain location.
date_recorded_min, date_recorded_max, seconds_min, seconds_max: If these properties are set to
a value, the function will return only results where the value of the respective field is no
lower or no higher than that value. This is useful for seeing responses to songs that are 3-5
minutes long, or to see if the responses to a certain song change significantly on/after a
certain day.
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

    let query = {
        select: {
            valence: searchOptions.showArrays,
            arousal: searchOptions.showArrays,
            time_sampled: searchOptions.showArrays,
            date_recorded: true,
            ad_played: true,
            users: {
                select: {
                    location: true
                }
            },
            songs: true,
        },

        where: {
            date_recorded: {
                gte: searchOptions.date_recorded_min,
                lte: searchOptions.date_recorded_max,
            },
    
            ad_played: searchOptions.ad_played,
    
            users: {
                location: searchOptions.location,
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
        
        case "location":
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

//Checks the affect data, user, and song, and throws an error if they don't have the expected properties.
module.exports.validateData = (affectData, user, song) => {
    if(!('valence' in affectData && 'arousal' in affectData && 'time_sampled' in affectData)){
        console.log("Error: Missing properties in affectData.");
        console.log(affectData);
        throw "Missing properties in affectData.";
    }

    module.exports.validateUser(user);

    if(!('song_uri' in song && 'title' in song && 'artist' in song &&
    'album' in song && 'seconds' in song)){
        console.log("Error: Missing properties in song");
        console.log(song);
        throw "Missing properties in song.";
    }

    if(affectData.valence.length !== affectData.arousal.length ||
    affectData.arousal.length !== affectData.time_sampled.length){
        console.log("Error: Affect data array lengths don't match.")
        console.log(affectData);

        throw "Affect data array lengths don't match.";
    }
    
    return true;
}

//Throws an error if the user doesn't have the expected properties
module.exports.validateUser = (user) => {
    if(!('user_id' in user)){
        console.log("Error: Missing user_id in user");
        console.log(user);
        throw "Missing user_id in user.";
    }

    if(!('location' in user)){
        console.log("Error: Missing location in user");
        console.log(user);
        throw "Missing location in user.";
    }

    return true;
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