import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/play_tab.dart';
import 'package:flutter_app/widgets/play_route.dart';

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
                "Soundbendor\nMusic Affect\nData Collection",
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
              ),
            ),
            Center(
              child: IconButton(
                iconSize: 72,
                icon: Icon(Icons.play_arrow),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PlayRoute()),
                  );
                },
              )
            ),
            const Center(
              child: Text(
                "Welcome! Press the Play button above to\n"
                "get started recording your emotional\n"
                "response to music!",
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}