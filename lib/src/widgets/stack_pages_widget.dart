import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stack_pages/src/model/stack_page.dart';
import 'package:flutter_stack_pages/src/widgets/animated_widget_placeholder.dart';
import 'package:flutter_stack_pages/src/widgets/custom_gesture_detector.dart';
import 'package:flutter_stack_pages/src/widgets/primary_button.dart';
import 'package:rxdart/rxdart.dart';

class StackPagesWidget extends StatefulWidget {
  /// A [List] of [StackPage] containing the number of pages to be displayed in the stack.
  final List<StackPage> stackPages;

  /// A [Function] to be executed on pressing the close Icon.
  final Function onClosePressed;

  /// A [Color] for the background of underlying container of the stack.
  final Color baseBackgroundColor;

  /// A [double] for the height of the banner of each page.
  final double headerHeight;

  StackPagesWidget({
    @required this.stackPages,
    this.baseBackgroundColor,
    this.onClosePressed,
    this.headerHeight = 100,
  }) : assert(stackPages != null);

  @override
  _StackPagesWidgetState createState() => _StackPagesWidgetState();
}

class _StackPagesWidgetState extends State<StackPagesWidget> {
  /// A[BehaviorSubject] for adding page index data.

  BehaviorSubject<int> _selectedPage;

  /// A[Stream] to listen to the currently selected page index.
  Stream<int> get selectedPage => _selectedPage;

  @override
  void initState() {
    _selectedPage = BehaviorSubject.seeded(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (_selectedPage.value > 0) {
          _selectedPage.add((_selectedPage.value - 1));
          return false;
        }
        return true;
      },
      child: Scaffold(
          body: Container(
        color: widget.baseBackgroundColor,
        child: StreamBuilder<int>(
            stream: selectedPage,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_closeButton, _faqButton],
                    ),
                  ),
                  ...widget.stackPages
                      .asMap()
                      .entries
                      .map((stackPageEntry) => AnimatedPlaceholder(
                            animationCurve: stackPageEntry.value.animationCurve,
                            animationDuration: stackPageEntry.value.animationDuration,
                            color: stackPageEntry.value.backgroundColor,
                            banner: stackPageEntry.value.banner,
                            maxHeight:
                                _screenHeight - ((stackPageEntry.key + 1) * widget.headerHeight),
                            child: stackPageEntry.value.page,
                            stackPageState: _getStackPageState(
                              snapshot.data.compareTo(stackPageEntry.key),
                            ),
                            onBannerTapped: () {
                              _selectedPage.add((stackPageEntry.key));
                            },
                          ))
                      .toList(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PrimaryButton(
                      onPressed: () {
                        if (_selectedPage.value + 1 < widget.stackPages.length)
                          _selectedPage.add((_selectedPage.value + 1));
                      },
                      buttonText: widget.stackPages[_selectedPage.value].buttonText,
                    ),
                  )
                ],
              );
            }),
      )),
    );
  }

  @override
  void dispose() {
    _selectedPage.close();
    super.dispose();
  }

  _getStackPageState(int value) {
    switch (value) {
      case 1:
        return StackPageState.DONE;
      case 0:
        return StackPageState.ACTIVE;
      case -1:
        return StackPageState.COLLAPSED;
    }
  }

  get _closeButton => CustomGestureDetector(
      child: Container(
        width: 28,
        height: 28,
        child: Icon(
          Icons.close,
          size: 20,
          color: Color(0xff9FA5A6),
        ),
      ),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff1d242a)),
      onPressed: widget.onClosePressed);

  get _faqButton => CustomGestureDetector(
        child: Container(
          width: 28,
          height: 28,
          child: Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff9FA5A6),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff1d242a)),
      );
}
