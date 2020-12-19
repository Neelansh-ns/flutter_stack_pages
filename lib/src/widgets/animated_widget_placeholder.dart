import 'package:flutter/material.dart';
import 'package:flutter_stack_pages/src/model/stack_page.dart';

class AnimatedPlaceholder extends StatelessWidget {
  final Widget child;
  final Widget banner;
  final double maxHeight;
  final Color color;
  final double minHeight;
  final StackPageState stackPageState;
  final Function onBannerTapped;
  final Duration animationDuration;
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
      this.animationCurve = Curves.easeIn})
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
                            parent: animation,
                            curve: Interval(0.5, 1.0, curve: Curves.decelerate))),
                        child: child,
                      ),
                  duration: Duration(milliseconds: 800),
                  reverseDuration: Duration(milliseconds: 800),
                  switchInCurve: animationCurve,
                  switchOutCurve: animationCurve,
                  layoutBuilder: (currentChild, previousChildren) => currentChild,
                  child: _getChildFromState),
            ),
          ),
        ));
  }

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
