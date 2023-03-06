import 'package:flutter/material.dart';

class PopupDialog<T> extends PopupRoute<T> {
  final String title;
  final String message;
  PopupDialog(
      {Key? key,
        required this.title,
        required this.message})
      : super();

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => title;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
      // Provide DefaultTextStyle to ensure that the dialog's text style
      // matches the rest of the text in the app.
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        // UnconstrainedBox is used to make the dialog size itself
        // to fit to the size of the content.
        child: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Text(title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
