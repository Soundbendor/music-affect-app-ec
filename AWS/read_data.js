const { PrismaClient } = require('@prisma/client')

//Returns an array containing every row in the response table
module.exports.readAllResponses = async () => {
    let client = new PrismaClient();

    let retVal = await client.responses.findMany({
        include: {
            users: {
                select: {
                    location: true
                }
            },
            songs: {
                select: {
                    title: true,
                    artist: true,
                    album: true,
                    seconds: true,
                }
            }
        }
    });

    await client.$disconnect();
    return retVal;
}

//Returns all responses of the given song_id
module.exports.readResponsesOfSong = async(song_id) => {
    let client = new PrismaClient();

    let retVal = await client.responses.findMany({
        where: {
            song_id: song_id
        }
    });

    await client.$disconnect();
    return retVal;
}

module.exports.readResponsesOfGenre = async(genre) => {
    let client = new PrismaClient();

    let retVal = await client.songs.findMany({
        where: {
            genre: genre
        },

        include: {
            responses: true
        }
    });

    await client.$disconnect();
    return retVal;
}
