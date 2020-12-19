import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  final Function onPressed;
  final BoxDecoration decoration;
  final Widget child;

  CustomGestureDetector({this.onPressed, this.decoration, this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: new CircleBorder(),
          onTap: onPressed,
          child: Ink(
            decoration: decoration,
            child: child,
          ),
        ));
  }
}
