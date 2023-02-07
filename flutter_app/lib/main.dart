import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/tapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

Future<http.Response> fetchData() {
  return http.get(Uri.parse(
      'https://97f186enh3.execute-api.us-west-2.amazonaws.com/test/helloworld'));
}

void main() async {
  var data = await fetchData();
  if (kDebugMode) {
    print(data.body);
  }
  await dotenv.load(fileName: '.env');
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: dotenv.env['CLIENT_ID'].toString(),
        redirectUrl: dotenv.env['REDIRECT_URL'].toString());
    print(result);
  }
  catch (e){
    print(e);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Affect Data',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Music Affect Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      affectDataArray.add(data);
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
          children:[
            // Here we get the connection status
            StreamBuilder<ConnectionStatus>(
              stream: SpotifySdk.subscribeConnectionStatus(),
              builder: (context, snapshot) {
                _connected = false;
                var data = snapshot.data;
                if (data != null) {
                  _connected = data.connected;
                }
                // and then we subscribe to player state
                return StreamBuilder<PlayerState>(
                  stream: SpotifySdk.subscribePlayerState(),
                  builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
                    var track = snapshot.data?.track;
                    print(track?.uri);
                    currentTrackImageUri = track?.imageUri;
                    var playerState = snapshot.data;

                    if (playerState == null || track == null) {
                      return Center(
                        child: Container(),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            '${track.name} by ${track.artist.name} from the album ${track.album.name}'),
                        Center( child: Row(
                          children: [
                            IconButton(
                              iconSize: 72,
                              icon: const Icon(Icons.play_arrow),
                              color: Colors.green,
                              onPressed: () async {
                                await SpotifySdk.play(spotifyUri: track?.uri ?? 'spotify:track:1bpnYrDCforv9ctJMzJRV8');
                              },
                            ),
                            IconButton(
                              iconSize: 72,
                              icon: const Icon(Icons.pause),
                              color: Colors.red,
                              onPressed: () async {
                                await SpotifySdk.pause();
                              },
                            ),
                          ],
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
            Text(affectDataArray.isNotEmpty
                ? affectDataArray
                    .map((item) => item.map((x) => x.toStringAsFixed(2)))
                    .toList()
                    .last
                    .toString()
                : ""),
            Tapper(addDataToArray: addDataToArray)
          ],
        ),
      ),
    );
  }
}
