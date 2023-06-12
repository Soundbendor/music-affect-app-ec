const { PrismaClient } = require('@prisma/client')
const { findUser, findSong } = require('./read_data')

module.exports.deleteUser = async (user_id) => {
    let client = new PrismaClient
    if(!findUser(user_id, client)){
        throw "User does not exist.";
    }

    await client.users.delete({
        where: {
            user_id: user_id
        }
    });

    client.$disconnect();
}

module.exports.deleteSong = async (song_uri) => {
    let client = new PrismaClient
    if(!findSong(song_uri, client)){
        throw "Song does not exist.";
    }

    await client.songs.delete({
        where: {
            song_uri: song_uri
        }
    });

    client.$disconnect();
}

module.exports.deleteResponse = async (user_id, song_uri) => {
    let client = new PrismaClient
    
    await client.responses.delete({
        where: {
            user_id_song_uri: {
                user_id: user_id,
                song_uri: song_uri,
            }
        },
    });

    client.$disconnect();
}