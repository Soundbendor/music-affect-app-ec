import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../models/current_recording.dart';
import '../widgets/tapper.dart';

class PlayTab extends StatefulWidget {
  const PlayTab({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<PlayTab> createState() => _PlayTabState();
}

class _PlayTabState extends State<PlayTab> {
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

  String intToTimeLeft(int value) {
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
    return Center(
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
              if (data != null) {
                _connected = data.connected;
              }
              // and then we subscribe to player state
              return StreamBuilder<PlayerState>(
                stream: SpotifySdk.subscribePlayerState(),
                builder: (BuildContext context,
                    AsyncSnapshot<PlayerState> snapshot) {
                  var track = snapshot.data?.track;
                  print(track);
                  currentTrackImageUri = track?.imageUri;
                  var playerState = snapshot.data;


                  if (playerState == null || track == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // if (currentRecording.isRecording && track.uri != currentRecording.currentRecordingTrack?.uri) {
                  //   setCurrentTrackEnded();
                  //   print(track.uri);
                  //   print(currentRecording.currentRecordingTrack?.uri);
                  // }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column( children: [
                        Row(children: [Text(playerState.playbackPosition.toString())],),
                        LinearProgressIndicator(
                          value: playerState.playbackPosition / track.duration!,
                          semanticsLabel: 'Linear progress indicator',
                        )
                      ],),
                      Text(
                          '${track.name} by ${track.artist
                              .name} from the album ${track.album.name}'),
                      Center(child: Row(
                        children:
                          currentRecording.isReadyToSubmit ? [
                            MaterialButton(onPressed: () async {
                              // need to do something like this
                              // var url = Uri.https('97f186enh3.execute-api.us-west-2.amazonaws.com', 'test/helloworld');
                              // var response = await http.post(url, body: jsonEncode({
                              //     "user_data": {
                              //       "user_id": 256,
                              //       "location": "nowhere"
                              //     },
                              //     "song_data": {
                              //       "song_id": currentRecording.currentRecordingTrack?.uri,
                              //       "title": currentRecording.currentRecordingTrack?.name,
                              //       "artist": currentRecording.currentRecordingTrack?.artist,
                              //       "album": currentRecording.currentRecordingTrack?.album,
                              //       "ms": currentRecording.currentRecordingTrack?.duration,
                              //     },
                              //     "response_data": currentRecording.affectDataArray
                              //   }));

                              print('Data recorded: ${currentRecording.affectDataArray}');
                              print('Current Track: ${currentRecording.currentRecordingTrack.toString()}');
                              print('Fake user data');
                              // print(response);
                            },
                                child: const Text("Submit Data")),
                          ] :
                          [IconButton(
                            iconSize: 72,
                            icon: const Icon(Icons.play_arrow),
                            color: Colors.green,
                            onPressed: playerState.isPaused ? () async {

                              await SpotifySdk.play(spotifyUri: track?.uri ??
                                  'spotify:track:1bpnYrDCforv9ctJMzJRV8');

                              setCurrentRecordingTrack(track);
                            } : null,
                          ),
                          IconButton(
                            iconSize: 72,
                            icon: const Icon(Icons.done),
                            color: Colors.red,
                            onPressed: () async {
                              setCurrentTrackEnded();
                              await SpotifySdk.pause();
                            },
                          ),]
                      )),
                    ],
                  );
                },
              );
            },
          ),
          // MaterialButton(onPressed: () async {
          //   var url = Uri.https('97f186enh3.execute-api.us-west-2.amazonaws.com', 'test/helloworld');
          //   var response = await http.post(url, body: jsonEncode({
          //     "user_data": {
          //       "user_id": 256,
          //       "location": "nowhere"
          //     },
          //     "song_data": {
          //       "song_id": 2,
          //       "title": "Example Song",
          //       "artist": "Example Artist",
          //       "genre": "Example Genre",
          //       "seconds": 256
          //     },
          //     "response_data": affectDataArray
          //   }));
          //   print('Response status: ${response.statusCode}');
          //   print('Response body: ${response.body}');
          // }, child: Text("send request")),
          // Text(currentRecording.affectDataArray.isNotEmpty
          //     ? affectDataArray
          //     .map((item) => item.map((x) => x.toStringAsFixed(2)))
          //     .toList()
          //     .last
          //     .toString()
          //     : ""),
          Tapper(addDataToArray: addDataToArray, shouldStartInterval: currentRecording.isRecording)
        ],
      ),
    );
  }
}