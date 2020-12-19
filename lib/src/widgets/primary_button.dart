import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color textColor;
  final Color backGroundColor;

  PrimaryButton(
      {this.buttonText,
      this.onPressed,
      this.backGroundColor = const Color(0xff404EA7),
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
            color: textColor,
          ),
        )),
      ),
    );
  }
}
