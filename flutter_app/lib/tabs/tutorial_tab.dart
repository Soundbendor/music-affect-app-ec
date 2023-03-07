import 'package:flutter/material.dart';
import '../widgets/tapper.dart';
import '../widgets/popup_dialog.dart';

class TutorialTab extends StatelessWidget {
  const TutorialTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: [
          const Center(
            child: Text(
              "On the song screen, you'll see a layout like this. Pressing "
              "the play button will begin the song, and you'll be able to "
              "tap on the grid to record your emotional response. Higher on "
              "the grid represents \"arousal\", or how excited and intense "
              "the music makes you feel. Lower on the grid represents lower "
              "arousal, less energy/intensity. Rightward on the grid "
              "represents higher \"valence\", which is how positive/happy "
              "the music makes you feel, and leftward is how sad/angry/"
              "negative you feel. Your most recent tap is recorded at one "
              "second intervals. When you're done, press the checkmark "
              "button and a \"Submit Data\" button will appear. Press it "
              "to send your response data to the database.",
            ),
          ),
          Center(
            child: Row(
              children: [
                IconButton(
                  iconSize: 72,
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).push(PopupDialog(
                      title: "You pressed the\nplay button!",
                      message: "Normally this will start the song.\n"
                          "Click outside this box to close it.",
                    ));
                  },
                ),
                IconButton(
                  iconSize: 72,
                  icon: const Icon(Icons.done),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).push(PopupDialog(
                      title: "You pressed the\ndone button!",
                      message: "Normally this will make the Submit Data\n"
                      "button appear. Click outside this box to close it.",
                    ));
                  },
                ),
              ]
          )),
          Center(
            child: Tapper(
              addDataToArray: (List<double> data) {},
              shouldStartInterval: false,
            )
          )
        ],
      ),
    );
  }
}
