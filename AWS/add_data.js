const { PrismaClient } = require('@prisma/client')
const { validateResponse, validateUser, findUser, validateSong, findSong } = require('./read_data')

/*The function that adds response data to the database is processResponse. It takes the parameters
(affect_data, user, song), each of which are objects containing the following data:
affect_data = {valence(float array), arousal(float array), time_sampled(float array),
heard_song_before(bool), heard_artist_before(bool), ad_played(bool)}
user = {user_id(int), age(int), gender(string), location(string), primary_language(string),
listening_habits(string), music_experience(string), hearing_loss(bool)}
song = {song_uri(string), title(string), artist(string), album(string), seconds(int)}
The function adds the song and user to the database (if they aren't already in there) and 
adds the response. If there's already a response with that song and user, it updates the old 
response with the new data. You may notice the date_recorded field in the Responses table. 
Don't worry about that, it's set to the current date automatically upon adding a response, 
and the updateResponse function also sets it to the current date.*/

//Adds a user object to the database. If it already exists, returns a message. Otherwise returns 0
module.exports.createUser = async (user) =>{
    try {
        validateUser(user);
    } catch (err) {
        throw err
    }

    let client = new PrismaClient();
    if(await findUser(user.user_id, client)){
        return "User with this id already exists.";
    }

    await client.users.create({
        data: user
    });

    await client.$disconnect();

    return 0;
}

//Updates a user. If no matching user exists, returns a message. Otherwise returns 0
module.exports.updateUser = async (user) =>{
    try {
        validateUser(user);
    } catch (err) {
        throw err
    }

    let client = new PrismaClient();
    if(!findUser(user.user_id, client)){
        return "Error: No user with this id.";
    }

    retVal = await client.users.update({
        data: user,
        where: {
            user_id: user.user_id
        }
    })

    await client.$disconnect();

    return 0;
}

//Adds a song object to the database. If it already exists, returns a message. Otherwise returns 0
module.exports.createSong = async (song) =>{
    try {
        validateSong(song);
    } catch (err) {
        throw err
    }

    let client = new PrismaClient();
    if(await findSong(song.song_uri, client)){
        return "Song with this uri already exists.";
    }

    await client.songs.create({
        data: song
    });

    await client.$disconnect();

    return 0;
}

//Updates a song. If no matching song exists, returns a message. Otherwise returns 0
module.exports.updateSong = async (song) =>{
    try {
        validateSong(song);
    } catch (err) {
        throw err
    }

    let client = new PrismaClient();
    if(!findSong(song.song_uri, client)){
        return "Error: No song with this id.";
    }

    retVal = await client.songs.update({
        data: song,
        where: {
            song_uri: song.song_uri
        }
    })

    await client.$disconnect();

    return 0;
}

/*Takes response data, a user object, a and song object, and adds data as follows:
If the user and/or song are not yet in the database, it adds them.
If there's no response with this song+user combination, it inserts the response.
If there's already a response with this song+user combo, it updates that response with
the new data and the current date.*/
module.exports.processResponse = async (affectData, user, song) =>{
    validateResponse(affectData);

    let retVal;
    let client = new PrismaClient();
    
    let exists = await client.responses.findUnique({
        where: {
            user_id_song_uri: {
                user_id: user.user_id,
                song_uri: song.song_uri,
            }
        }
    });
    if(exists == null){//If the response doesn't exist yet, insert it

        //Add the song and user if they don't exist
        await module.exports.createUser(user);
        await module.exports.createSong(song);

        retVal = await client.responses.create({
            data: {
                user_id: user.user_id,
                song_uri: song.song_uri,
                valence: affectData.valence,
                arousal: affectData.arousal,
                time_sampled: affectData.time_sampled,
                heard_song_before: affectData.heard_song_before,
                heard_artist_before: affectData.heard_artist_before,
                ad_played: affectData.ad_played,
            }
        });
    }
    else{//If the response already exists, update it
        retVal = await client.responses.update({
            data: {
                valence: affectData.valence,
                arousal: affectData.arousal,
                time_sampled: affectData.time_sampled,
                date_recorded: new Date(),
                heard_song_before: affectData.heard_song_before,
                heard_artist_before: affectData.heard_artist_before,
                ad_played: affectData.ad_played,
            },
            where: {
                user_id_song_uri: {
                    user_id: user.user_id,
                    song_uri: song.song_uri,
                }
            },
        });
    }

    await client.$disconnect();

    return retVal;
}