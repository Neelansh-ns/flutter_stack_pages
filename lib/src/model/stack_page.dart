import 'package:flutter/material.dart';

class StackPage {
  /// A [Widget] to be displayed as page.
  Widget page;

  /// A [Widget] to be displayed as banner.
  Widget banner;

  /// A [Color] for background of the page.

  Color backgroundColor;

  /// A [Text] for primary button on the page.

  String buttonText;

  Curve animationCurve;
  Duration animationDuration;

  StackPage({
    @required this.page,
    this.banner,
    this.backgroundColor,
    this.buttonText,
    this.animationCurve = Curves.decelerate,
    this.animationDuration = const Duration(milliseconds: 600),
  });
}

/// States for the pages.
///
/// [ACTIVE] => state for the current page.
/// [COLLAPSED] => state for the upcoming page(s).
/// [DONE] => state for the previous page(s).
enum StackPageState { ACTIVE, COLLAPSED, DONE }
