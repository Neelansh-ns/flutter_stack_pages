import 'package:flutter/material.dart';

class StackPage {
  Widget page;
  Widget banner;
  Color backgroundColor;
  String buttonText;

  StackPage({
    @required this.page,
    this.banner,
    this.backgroundColor,
    this.buttonText,
  });
}

enum StackPageState { ACTIVE, COLLAPSED, DONE }
