const { getClient } = require('./get_client');

//values = [affect_data, song_id, user_id]
async function updateResponse(values, client){
    return client.query('UPDATE Responses SET affect_data = $1, date_recorded = CURRENT_DATE WHERE song_id = $2 AND user_id = $3', values);
}

//Returns the row with the given primary key. If it doesn't exist, returns null
async function findThing(table, values, client){
    const RESPONSE = 'SELECT * FROM Responses WHERE song_id = $1 AND user_id = $2';
    const SONG = 'SELECT * FROM Songs WHERE song_id = $1';
    const USER = 'SELECT * FROM Users WHERE user_id = $1';

    switch(table){
        case 'r':
            table = RESPONSE;
            break;
        case 's':
            table = SONG;
            break;
        case 'u':
            table = USER;
            break;
        default:
            console.log("ERROR: Invalid table in function findThing.")
            return "ERROR: Invalid table in function findThing.";
    }

    let res = await client.query(table, values);

    if(res.rows.length == []){
        return null;
    }
    else{
        console.log("ALERT: res.rows = " + res.rows);
        return res.rows[0];
    }
    //return ((res.rows !== []) ? res.rows : null);
}

//Deprecated
addThingOld = async (table, values) => {
    const RESPONSE = 'INSERT INTO Responses(song_id, user_id, affect_data) VALUES ($1, $2, $3)';
    const SONG = 'INSERT INTO Songs(song_id, title, artist, genre, seconds) VALUES ($1, $2, $3, $4, $5)';
    const USER = 'INSERT INTO Users(user_id, location) VALUES ($1, $2)';
    let client;

    switch(table){
        case 'r':
            table = RESPONSE;
            break;
        case 's':
            table = SONG;
            break;
        case 'u':
            table = USER;
            break;
        default:
            return "ERROR: Invalid table in function addThing.";
    }
    
    let retVal = getClient()
        .then(clientVal => {
            client = clientVal;
            return client.query(table, values);
        })
        .then(res => {
            client.end();
            return res;
        })
        .catch(e => e)


    return retVal;
}

//Adds something if it doesn't exist. table = r for response, s for song, u for user
addThing = async (table, values, client) => {
    const RESPONSE = 'INSERT INTO Responses(song_id, user_id, affect_data) VALUES ($1, $2, $3)';
    const SONG = 'INSERT INTO Songs(song_id, title, artist, genre, seconds) VALUES ($1, $2, $3, $4, $5)';
    const USER = 'INSERT INTO Users(user_id, location) VALUES ($1, $2)';

    //If the given primary key already exists, return without doing anything
    pkey = (table === 'r') ? [values[0], values[1]] : [values[0]];
    let exists = await findThing(table, pkey, client);
    if(exists !== null){
        return
    }

    switch(table){
        case 'r':
            table = RESPONSE;
            break;
        case 's':
            table = SONG;
            break;
        case 'u':
            table = USER;
            break;
        default:
            console.log("ERROR: Invalid table in function addThing.")
            return "ERROR: Invalid table in function addThing.";
    }
    
    return client.query(table, values);
}

//Deprecated
addSong = async (values) => {
    let client;
    
    let retVal = getClient()
        .then(clientVal => {
            client = clientVal;
            return client.query('INSERT INTO Songs(song_id, title, artist, genre, seconds) VALUES ($1, $2, $3, $4, $5)', values);
        })
        .then(res => {
            client.end();
            return res;
        })
        .catch(e => e)


    return retVal;
}

/*Takes response data, a song object, and a user object, and adds data as follows:
If the song and/or user are not yet in the database, it adds them.
If there's no response with this song+user combination, it just inserts the response.
If there's already a response with this song+user combo, it updates that response with
the new data and the current date.
The affect_data argument must be an object, but currently doesn't need any particular format.*/
module.exports.processResponse = async (affect_data, song, user) =>{
    let res;
    let client = await getClient();
    
    let exists = await findThing('r', [song.song_id, user.user_id], client);
    if(exists == null){//If the response doesn't exist yet, insert it

        //Add the song and user in case they don't exist
        await addThing('s', [song.song_id, song.title, song.artist, song.genre, song.seconds], client);
        await addThing('u', [user.user_id, user.location], client);

        res = await addThing('r', [song.song_id, user.user_id, affect_data], client);
    }
    else{//If the response already exists, update it
        res = await updateResponse([affect_data, song.song_id, user.user_id], client);
    }

    client.end();

    return res;
}