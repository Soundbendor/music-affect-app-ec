const { getClient } = require('./get_client');

//Deprecated
readAllResponsesOld = async () => {
    let client;

    let retVal = getClient()
        .then(clientVal => {
            client = clientVal;
            return client.query('SELECT * FROM Responses')
        })
        .then(res => {
            client.end();
            return res.rows;
        })
        .catch(e => {
            return e;
        })

    return retVal;
}

//Spits out an array containing every row in the response table
module.exports.readAllResponses = async () => {
    let client = await getClient();

    let retVal = await client.query('SELECT * FROM Responses');

    client.end();
    return retVal.rows;
}

//Unused
readAllSongs = async () => {
    let client;

    let retVal = getClient()
        .then(clientVal => {
            client = clientVal;
            return client.query('SELECT * FROM Songs')
        })
        .then(res => {
            client.end();
            return res.rows;
        })
        .catch(e => {
            return e;
        })

    return retVal;
}