import 'dart:async';

import 'package:flutter/material.dart';

import '../models/affect_coordinates.dart';

class Tapper extends StatefulWidget {
  final void Function(List<double> data) addDataToArray;
  final bool shouldStartInterval;

  const Tapper(
      {Key? key,
      required this.addDataToArray,
      required this.shouldStartInterval})
      : super(key: key);

  @override
  State<Tapper> createState() => _TapperState();
}

class _TapperState extends State<Tapper> {
  final gridSize = 180.0;
  final circleRadius = 0.0;
  final coordinates = AffectCoordinates();
  Timer? timer;

  double count = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      // only start the algorithm to collect data if the timer is null and we should start interval
      if (timer == null && widget.shouldStartInterval) {
        collectDataOnInterval();
      }
      // otherwise, lets cancel it and set the instance variable to null
      if (timer != null && !widget.shouldStartInterval) {
        if (timer!.isActive) {
          timer?.cancel();
          timer = null;
        }
      }
    }
  }

  void addCoordinatesOnTap(double x, double y) {
    setState(() {
      coordinates.updateCoordinates(x, y);
    });
  }

  void collectDataOnInterval() {
    // this creates a function that loops every 1 second and adds whatever the
    // latest data tapped was to the array that will be sent to server
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        timer = t;
        widget.addDataToArray(coordinates.generateArray());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (PointerDownEvent event) {
          // Global screen position.
          print(
              "Global position x:${event.position.dx}, y:${event.position.dy}");
          // Position relative to where this widget starts.
          print(
              "Relative position: x:${event.localPosition.dx}, y:${event.localPosition.dy}");

          var x = ((event.localPosition.dx - 17) - 180) / 180;
          var y = ((event.localPosition.dy - 180) * -1) / 180;
          // here we update AffectCoordinates, that the interval alg will add to
          // the CurrentRecording array, to eventually be sent to the server
          addCoordinatesOnTap(x, y);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Material(
                  color: Colors.pink[100],
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(circleRadius)),
                            color: Colors.transparent),
                        width: gridSize,
                        height: gridSize,
                      ))),
              Material(
                  color: Colors.orange[100],
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(circleRadius)),
                            color: Colors.transparent),
                        width: gridSize,
                        height: gridSize,
                        // color: Colors.green,
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Material(
                  color: Colors.grey[300],
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(circleRadius)),
                            color: Colors.transparent),
                        width: gridSize,
                        height: gridSize,
                        // color: Colors.red,
                      ))),
              Material(
                  color: Colors.blue[100],
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(circleRadius)),
                              color: Colors.transparent),
                          width: gridSize,
                          height: gridSize)))
            ])
          ],
        ));
  }
}
