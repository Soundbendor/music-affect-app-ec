import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
            const Center(
              child: Icon(
                Icons.music_note_rounded,
                size: 50
              )
            ),
            const Center(
              child: Text(
                "Welcome! Press the button above to\n"
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