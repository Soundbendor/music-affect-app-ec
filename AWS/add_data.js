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
and the updateResponse function also sets it to the current date.
Potential changes: Is there any more data that should be stored in song/user/data tables? 
Any other tables that should be added? Should errors be reported in the return value?*/


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

//Same as addUser, but for songs. If there's a good way to combine these two, please let me know.
async function addSong(data, client){
    let exists = await client.songs.findUnique({
        where: {
            song_id: data.song_id
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

/*Takes response data, a song object, and a user object, and adds data as follows:
If the song and/or user are not yet in the database, it adds them.
If there's no response with this song+user combination, it inserts the response.
If there's already a response with this song+user combo, it updates that response with
the new data and the current date.
The affect_data argument must be an object, but currently doesn't need any particular format.*/
module.exports.processResponse = async (affect_data, song, user) =>{
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
}