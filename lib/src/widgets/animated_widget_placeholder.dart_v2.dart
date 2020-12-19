import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_stack_pages/src/model/stack_page.dart';

class SlideVisible extends StatefulWidget {
  ///The widget that is shown or hidden by this widget.
  final Widget child;
  final Widget banner;

  ///The Offset of this widget when visible is false.
  ///
  ///Defaults to Offset(0, -1.1), which will slide the widget up by
  ///slightly more than its height when the widget is hidden.

  ///The [Offset] of this widget when [visible] is true.
  ///
  ///Defaults to Offset(0,0).
  final double maxHeight;
  final double minHeight;
  final StackPageState stackPageState;
  final Function onBannerTapped;
  final Duration animationDuration;
  final Curve animationCurve;

  ///The [Duration] of the slide animation.
  ///
  ///Defaults to 300ms.
  final Duration duration;

  ///The [Curve] that the slide animation will follow.
  ///
  ///Defaults to [Curves.linear]
  final Curve curve;
  final Offset hiddenOffset;

  ///The [Offset] of this widget when [visible] is true.
  ///
  ///Defaults to Offset(0,0).
  final Offset visibleOffset;

  SlideVisible(
      {Key key,
      @required this.child,
      @required this.banner,
      this.maxHeight = 220,
      this.minHeight = 0,
      this.stackPageState,
      this.hiddenOffset = const Offset(0, 1.1),
      this.visibleOffset = const Offset(0, 0),
      this.duration = const Duration(milliseconds: 700),
      this.curve = Curves.linear,
      this.onBannerTapped,
      this.animationDuration = const Duration(milliseconds: 700),
      this.animationCurve = Curves.easeIn})
      : super(key: key);

  @override
  _SlideVisibleState createState() => _SlideVisibleState();
}

class _SlideVisibleState extends State<SlideVisible> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation = Tween<Offset>(begin: widget.hiddenOffset, end: widget.visibleOffset)
        .animate(CurvedAnimation(
      curve: widget.curve,
      parent: _controller,
    ));

    // Ensure that the animation will not play if the widget starts as visible.
    if (widget.stackPageState == StackPageState.ACTIVE ||
        widget.stackPageState == StackPageState.DONE) {
      _controller.value = _controller.upperBound;
    }
  }

  @override
  void didUpdateWidget(SlideVisible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stackPageState != oldWidget.stackPageState) {
      if (widget.stackPageState == StackPageState.COLLAPSED) {
        _controller.reverse();
      }
      if (widget.stackPageState == StackPageState.ACTIVE ||
          widget.stackPageState == StackPageState.DONE) {
        _controller.forward();
      } else if (widget.stackPageState == StackPageState.DONE) {
        // _controller.value = _controller.upperBound;
      } else
        _controller.reverse();
    }
    // else{
    //   print('neeeee ttttttt ${widget.stackPageState} ');
    //   if(widget.stackPageState == StackPageState.DONE)
    // _controller.reverse();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: widget.onBannerTapped,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: AnimatedSwitcher(
              duration: widget.animationDuration,
              reverseDuration: widget.animationDuration,
              switchInCurve: widget.animationCurve,
              switchOutCurve: widget.animationCurve,
              layoutBuilder: (currentChild, previousChildren) => currentChild,
              child: _getChildFromState),
        ),
      ),
    );
  }

  Widget get _getChildFromState {
    switch (widget.stackPageState) {
      case StackPageState.ACTIVE:
      case StackPageState.COLLAPSED:
        return GestureDetector(
          onTap: () {
            // setState(() {
            //   widget.maxHeight = 40;
            // });
          },
          child: SingleChildScrollView(
            child: widget.child,
          ),
        );
      // return Container(color: Colors.white,height: 70,);
      case StackPageState.DONE:
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.onBannerTapped();
            });
          },
          child: Container(
              height: 100, child: widget.banner ?? Container()),
        );
      default:
        return SizedBox();
    }
  }

  @override
  void dispose() {
    print('neeeee disposing ....');
    _controller.dispose();
    super.dispose();
  }
}
