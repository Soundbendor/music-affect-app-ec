import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/home_tab.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
  } catch (e) {
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
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Music Affect Data'),
                bottom: const TabBar(tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.question_mark)),
                ]),
              ),
              body: const Padding(
                padding: EdgeInsets.all(10),
                child: TabBarView(children: [HomeTab(), Text('Tutorial')]),
              ))),
    );
  }
}
