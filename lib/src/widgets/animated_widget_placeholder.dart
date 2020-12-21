import 'package:flutter/material.dart';
import 'package:flutter_stack_pages/flutter_stack_pages.dart';
import 'package:flutter_stack_pages/src/model/stack_page.dart';

class AnimatedPlaceholder extends StatelessWidget {
  ///The widget(page content) that is shown or hidden by this widget.
  final Widget child;

  ///The widget(banner content) that is shown or hidden by this widget.
  final Widget banner;

  ///The maximum height of the page from bottom to top of the screen.
  final double maxHeight;

  ///The [Color] for the background of each page.
  final Color color;

  ///The minimum height of the page from bottom to top of the screen.
  final double minHeight;

  ///The [StackPageState] of the page.
  final StackPageState stackPageState;

  ///The function to be executed on click of the banner.

  final Function onBannerTapped;

  ///The [Duration] for animating the page.

  final Duration animationDuration;

  ///The [Curve] for animating the page.
  final Curve animationCurve;

  AnimatedPlaceholder(
      {Key key,
      @required this.child,
      @required this.banner,
      @required this.color,
      this.maxHeight = 200,
      this.minHeight = 0,
      this.stackPageState = StackPageState.COLLAPSED,
      this.onBannerTapped,
      this.animationDuration = const Duration(milliseconds: 600),
      this.animationCurve = Curves.decelerate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          height: _getHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            child: Container(
              color: color,
              child: AnimatedSwitcher(
                  transitionBuilder: (child, animation) => FadeTransition(
                        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                            parent: animation, curve: Interval(0.4, 1, curve: Curves.easeInOut))),
                        child: child,
                      ),
                  duration: Duration(milliseconds: 800),
                  reverseDuration: Duration(milliseconds: 800),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeIn,
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                        alignment: Alignment.topCenter,
                      ),
                  child: _getChildFromState),
            ),
          ),
        ));
  }

  /// A getter to get the child widget to be displayed based on the [StackPageState].

  Widget get _getChildFromState {
    switch (stackPageState) {
      case StackPageState.ACTIVE:
      case StackPageState.COLLAPSED:
        return SingleChildScrollView(
          child: child,
        );
      case StackPageState.DONE:
        return GestureDetector(
          onTap: onBannerTapped,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                    // height: StackPageWidgetConstants.HEADER_HEIGHT,
                    child: banner ?? Container()),
              ],
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }

  /// A getter to get the height of the page to be displayed based on the [StackPageState].

  double get _getHeight {
    switch (stackPageState) {
      case StackPageState.ACTIVE:
      case StackPageState.DONE:
        return maxHeight;
        break;
      case StackPageState.COLLAPSED:
        return minHeight;
      default:
        return minHeight;
    }
  }
}
