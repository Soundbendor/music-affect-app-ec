import 'package:flutter/material.dart';
import 'package:flutter_app/colors/osu_colors.dart';
import 'package:flutter_app/routes/play_route.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: [
          Center(
            child: Text(
              "Music Affect\nData Collection",
              textAlign: TextAlign.center,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
          ),
          Center(
              child: IconButton(
            iconSize: 72,
            icon: const Icon(Icons.music_note),
            color: OSUSecondaryColors.pineStand,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayRoute()),
              );
            },
          )),
          const Center(
            child: Text(
                "Welcome! \n\n"
                "Make sure you have the Spotify app\n"
                "up and running on your device,\n"
                "then press the musical note above \nto start recording your emotional\nresponse to music."
                "\n\nYou can also navigate to the tutorial tab \nto learn how the process works.\n\n",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
