const { getClient } = require('./get_client');

module.exports.readAllResponses = async () => {
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

module.exports.readAllSongs = async () => {
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