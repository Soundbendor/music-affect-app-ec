//source:https://medium.flutterdevs.com/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1 
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  @override
  _Timerr createState() => _Timerr();
}

class _Timerr extends State<Timer> with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerS {
    Duration duration = controller.duration !* controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData themeData = Theme.of(context);

    return Column(
        children: [Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: FractionalOffset.center,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  timerS,
                                  style: TextStyle(
                                      fontSize: 112.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],

                    ),
                    AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          return FloatingActionButton.extended(
                              onPressed: () {
                                if (controller.isAnimating)
                                  controller.stop();
                                else {
                                  controller.reverse(
                                      from: controller.value == 0.0
                                          ? 1.0
                                          : controller.value);
                                }
                              },
                              icon: Icon(controller.isAnimating
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              label: Text(
                                  controller.isAnimating ? "Pause" : "Play"));
                        }),
                  ],
                ),
              ),
            ]),
        ]);
  }}