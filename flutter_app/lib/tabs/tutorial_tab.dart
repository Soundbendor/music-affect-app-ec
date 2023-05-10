import 'package:flutter/material.dart';
import 'package:flutter_app/colors/color_blind_safe_colors.dart';
import 'package:flutter_app/colors/osu_colors.dart';
import '../widgets/tapper.dart';
import '../widgets/popup_dialog.dart';

class TutorialTab extends StatelessWidget {
  const TutorialTab({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();

    return Material(
        child: PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
          // PAGE 0
          Column(children: [
            TextButton(
                // NEXT button
                onPressed: () {
                  _controller.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Text("Next")),
            const Text(
              "In this app, you will use a valence/arousal chart to report your emotional response to a song."
              "\n\nHigh arousal represents feelings of high energy, while low arousal represents feelings of low energy."
              "\n\nHigh valence represents positive feelings, while low valence represents negative feelings.",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            Tapper(
              addDataToArray: (List<double> tutorialData) {},
              shouldStartInterval: false,
            ),
          ]),

          // PAGE 1
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    // BACK button
                    onPressed: () {
                      _controller.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Text("Back")),
                TextButton(
                    // NEXT button
                    onPressed: () {
                      _controller.animateToPage(2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Text("Next")),
              ],
            ),
            const Text(
              "The data collection screen looks like this."
              "\n\nTapping the play button will begin the data collection process. Your selected song will begin to play through the Spotify app."
              "\n\nAs you listen to the song, tap locations on the chart that represent what the song is making you feel in each moment.",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            Tapper(
              addDataToArray: (List<double> tutorialData) {},
              shouldStartInterval: false,
            )
          ]),

          // PAGE 2
          Column(children: [
            TextButton(
                // BACK button
                onPressed: () {
                  _controller.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Text("Back")),
            const Text(
              "When the song ends, you will be asked to submit your data to the database."
              "\n\nYou can report data for the same song multiple times, but your most recent report will replace any earlier reports. You can also always choose to delete all of your response data from the settings screen.",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            Tapper(
              addDataToArray: (List<double> tutorialData) {},
              shouldStartInterval: false,
            ),
          ]),
        ]));
  }
}
