import 'package:flutter/material.dart';

class Tapper extends StatefulWidget {
  const Tapper({Key? key}) : super(key: key);

  @override
  State<Tapper> createState() => _TapperState();
}

class _TapperState extends State<Tapper> {
  final gridSize = 180.0;
  final circleRadius = 0.0;
  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (PointerDownEvent event) {
          // Global screen position.
          print("Global position x:${event.position.dx}, y:${event.position.dy}");
          // Position relative to where this widget starts.
          print("Relative position: x:${event.localPosition.dx}, y:${event.localPosition.dy}");
          print(((event.localPosition.dy - 180) * -1) / 180 );
          print(((event.localPosition.dx - 17) - 180) / 180);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center
                ,children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(circleRadius)),
                    color: Colors.pink[100]
                ),
                width: gridSize,
                height: gridSize,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(circleRadius)),
                    color: Colors.orange[100]
                ),
                width: gridSize,
                height: gridSize,
                // color: Colors.green,
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(circleRadius)),
                    color: Colors.grey[300]
                ),
                width: gridSize,
                height: gridSize,
                // color: Colors.red,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(circleRadius)),
                      color: Colors.blue[100]
                  ),
                  width: gridSize,
                  height: gridSize
              )
            ])
          ],
        ));
  }
}