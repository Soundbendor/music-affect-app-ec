import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../models/current_recording.dart';
import '../widgets/tapper.dart';
import '../widgets/popup_dialog.dart';

class PlayRoute extends StatefulWidget {
  const PlayRoute({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<PlayRoute> createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayRoute> {
  final currentRecording = CurrentRecording();
  final List<List<double>> affectDataArray = [];
  ImageUri? currentTrackImageUri;
  bool _connected = false;

  void addDataToArray(List<double> data) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      currentRecording.addDataToArray(data);
    });
  }

  String intToTime(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    final minutesLeft = m.toString().padLeft(2, '0');
    final secondsLeft = s.toString().padLeft(2, '0');

    String result = "$minutesLeft:$secondsLeft";

    return result;
  }

  void setCurrentRecordingTrack(Track? track) {
    setState(() {
      currentRecording.currentRecordingTrack = track;
    });
  }

  void setCurrentTrackEnded() {
    setState(() {
      currentRecording.currentTrackEnded();
    });
  }

  void resetCurrentRecording() {
    setState(() {
      currentRecording.resetCurrentRecording();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(title: const Text('Music Affect Data')),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Here we get the connection status
              StreamBuilder<ConnectionStatus>(
                stream: SpotifySdk.subscribeConnectionStatus(),
                builder: (thing, connectionSnapshot) {
                  _connected = false;
                  var data = connectionSnapshot.data;
                  print(data?.connected);
                  if (data != null) {
                    _connected = data.connected;
                  }
                  // and then we subscribe to player state
                  return StreamBuilder<PlayerState>(
                    stream: SpotifySdk.subscribePlayerState(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PlayerState> snapshot) {
                      var track = snapshot.data?.track;
                      var playerState = snapshot.data;

                      if (playerState == null || track == null) {
                        return Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                await dotenv.load(fileName: '.env');
                                try {
                                  var result =
                                      await SpotifySdk.connectToSpotifyRemote(
                                          clientId: dotenv.env['CLIENT_ID']
                                              .toString(),
                                          redirectUrl: dotenv
                                              .env['REDIRECT_URL']
                                              .toString(),
                                          spotifyUri:
                                              'spotify:track:1bpnYrDCforv9ctJMzJRV8');
                                  print(result);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text("Connect to Spotify")),
                        );
                      }
                      // set the current recording track if it hasn't already been set
                      if (Platform.isIOS &&
                          currentRecording.currentRecordingTrack == null) {
                        currentRecording.currentRecordingTrack = track;
                      }
                      // Here we check to see if the track has changed
                      // if so, update the currentRecordings state and pause
                      if (!currentRecording.isReadyToSubmit &&
                          currentRecording.isRecording &&
                          track.uri !=
                              currentRecording.currentRecordingTrack?.uri) {
                        currentRecording.currentTrackEnded();
                        SpotifySdk.pause();
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                children: const [Text('Time Left:')],
                              ),
                              LinearProgressIndicator(
                                value: playerState.playbackPosition /
                                    track.duration!,
                                semanticsLabel: 'Linear progress indicator',
                              )
                            ],
                          ),
                          Text(
                              '${track.name} by ${track.artist.name} from the album ${track.album.name}'),
                          Center(
                              child: Row(
                                  children: currentRecording.isReadyToSubmit
                                      ? [
                                          ElevatedButton(
                                              onPressed: () async {
                                                var url = Uri.https(
                                                    'qzb9rm0k6c.execute-api.us-west-2.amazonaws.com',
                                                    'test/resource');
                                                Random rand = Random();

                                                var valence = [];
                                                var arousal = [];
                                                var time_sampled = [];
                                                for (var i = 0;
                                                    i <
                                                        currentRecording
                                                            .affectDataArray
                                                            .length;
                                                    i++) {
                                                  time_sampled.add(
                                                      currentRecording
                                                              .affectDataArray[
                                                          i][0]);
                                                  valence.add(currentRecording
                                                      .affectDataArray[i][1]);
                                                  arousal.add(currentRecording
                                                      .affectDataArray[i][2]);
                                                }

                                                var serverResponse =
                                                    await http.post(url,
                                                        body: jsonEncode({
                                                          "user_data": {
                                                            "user_id": rand
                                                                .nextInt(9999),
                                                            "location":
                                                                "nowhere"
                                                          },
                                                          "song_data": {
                                                            "song_uri":
                                                                track.uri,
                                                            "title": track.name,
                                                            "artist": track
                                                                .artist.name,
                                                            "album": track
                                                                .album.name,
                                                            "seconds": track
                                                                    .duration ~/
                                                                1000, // Spotify SDK returns ms but we want to store seconds
                                                          },
                                                          "affect_data": {
                                                            "valence": valence,
                                                            "arousal": arousal,
                                                            "time_sampled":
                                                                time_sampled,
                                                          }
                                                        }));

                                                print(
                                                    'Data recorded: ${currentRecording.affectDataArray}');
                                                print(
                                                    'Current Track: ${track.name}');
                                                print('Fake user data');
                                                print(
                                                    'Server Response: $serverResponse');
                                                // go back to home page
                                                Navigator.pop(context);

                                                Navigator.of(context)
                                                    .push(PopupDialog(
                                                  title:
                                                      "Status Code:\n${serverResponse.statusCode}",
                                                  message: serverResponse.body,
                                                ));
                                              },
                                              child: const Text("Submit Data")),
                                        ]
                                      : [
                                          IconButton(
                                            iconSize: 72,
                                            icon: const Icon(Icons.play_arrow),
                                            color: Colors.green,
                                            onPressed: playerState.isPaused
                                                ? () async {
                                                    await SpotifySdk.play(
                                                        spotifyUri:
                                                            'spotify:track:1bpnYrDCforv9ctJMzJRV8');

                                                    setCurrentRecordingTrack(
                                                        track);
                                                  }
                                                : null,
                                          ),
                                          IconButton(
                                            iconSize: 72,
                                            icon: const Icon(Icons.done),
                                            color: Colors.red,
                                            onPressed: () async {
                                              setCurrentTrackEnded();
                                              await SpotifySdk.pause();
                                            },
                                          ),
                                        ])),
                        ],
                      );
                    },
                  );
                },
              ),
              Text(currentRecording.affectDataArray.isNotEmpty
                  ? currentRecording.affectDataArray
                      .map((item) => item.map((x) => x.toStringAsFixed(2)))
                      .toList()
                      .last
                      .toString()
                  : ""),
              Tapper(
                  addDataToArray: addDataToArray,
                  shouldStartInterval: currentRecording.isRecording)
            ],
          ),
        ));
  }
}
