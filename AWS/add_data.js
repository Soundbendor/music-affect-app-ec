const { PrismaClient } = require('@prisma/client')

/*The function that adds response data to the database is processResponse. It takes the parameters
(affect_data, song, user), each of which are objects containing the following data:
song = {song_id(int), title(string), artist(string), genre(string), length(int, in seconds)}
user = {user_id(int), location(string)}
affect_data = {literally whatever you want, as demonstrated by the "grandma" field in the 
test_connect.js example}
The database doesn't care about the formatting of the affect data. It doesn't even need to be 
consistent, but it probably should be eventually. Just pass in the three objects in the right 
order and the function will do its thing.
What it does is add the song and user to the database (if they aren't already in there) and 
adds the response. If there's already a response with that song and user, it updates the old 
response with the new data. You may notice the date_recorded field in the Response table. 
Don't worry about that, it's set to the current date automatically upon adding a response, 
and the updateResponse function also sets it to the current date.*/

/*Checks the data and throws an error if there's a problem. Minimally used now, might be
expanded in the future.*/
function validateData(affectData, user, song){
    if(affectData.valance.length !== affectData.arousal.length ||
        affectData.arousal.length !== affectData.time_sampled.length)
        {
            console.log("Error: affect data array lengths don't match.")
            console.log(affectData.valance);
            console.log(affectData.arousal);
            console.log(affectData.time_sampled);

            throw "Affect data array lengths don't match.";
        }
    
    return true;
}

//Checks if a user exists. If it doesn't, it adds it. If it does, returns null.
async function addUser(data, client){
    let exists = await client.users.findUnique({
        where: {
            user_id: data.user_id
        }
    })
    if(exists === null){
        retVal = await client.users.create({
            data: data
        });
    }
    else{ retVal = null; }
    
    return retVal;
}

/*Takes response data, a song object, and a user object, and adds data as follows:
If the song and/or user are not yet in the database, it adds them.
If there's no response with this song+user combination, it inserts the response.
If there's already a response with this song+user combo, it updates that response with
the new data and the current date.
The affect_data argument must be an object, but currently doesn't need any particular format.*/
/*module.exports.processResponse = async (affect_data, song, user) =>{
    let retVal;
    let client = new PrismaClient;
    
    let exists = await client.responses.findUnique({
        where: {
            user_id_song_id: {
                user_id: user.user_id,
                song_id: song.song_id,
            }
        }
    });
    if(exists == null){//If the response doesn't exist yet, insert it

        //Add the song and user if they don't exist
        await addUser(user, client);
        await addSong(song, client);

        retVal = await client.responses.create({
            data: {
                user_id: user.user_id,
                song_id: song.song_id,
                affect_data: affect_data,
            }
        });
    }
    else{//If the response already exists, update it
        retVal = await client.responses.update({
            data: {
                affect_data: affect_data,
                date_recorded: new Date(),
            },
            where: {
                user_id_song_id: {
                    user_id: user.user_id,
                    song_id: song.song_id,
                }
            },
        });
    }

    await client.$disconnect();

    return retVal;
}*/

//Functions that use the new database schema, with the song table's genre removed and song_id replaced with song_uri
async function addSong(data, client){
    let exists = await client.songs.findUnique({
        where: {
            song_uri: data.song_uri
        }
    })
    if(exists === null){
        retVal = await client.songs.create({
            data: data
        });
    }
    else{ retVal = null; }
    
    return retVal;
}

module.exports.processResponse = async (affectData, user, song) =>{
    if(validateData(affectData, user, song) === false){
        console.log("Uh oh, invalid data in processResponse. Updating database anyway lol");
    }

    let retVal;
    let client = new PrismaClient;
    
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
        await addUser(user, client);
        await addSong(song, client);

        retVal = await client.responses.create({
            data: {
                user_id: user.user_id,
                song_uri: song.song_uri,
                valance: affectData.valance,
                arousal: affectData.arousal,
                time_sampled: affectData.time_sampled,
            }
        });
    }
    else{//If the response already exists, update it
        retVal = await client.responses.update({
            data: {
                valance: affectData.valance,
                arousal: affectData.arousal,
                time_sampled: affectData.time_sampled,
                date_recorded: new Date(),
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