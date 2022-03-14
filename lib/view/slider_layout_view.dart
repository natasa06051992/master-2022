import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_master/model/slider.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/widgets/slide_dots.dart';

import '../config/constants.dart';
import '../widgets/slide_items/slide_item.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Scaffold(
        appBar: AppBar(title: const Text('Welcome')),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: sliderArrayList.length,
                  itemBuilder: (ctx, i) => SlideItem(i),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    if (_currentPage == 1)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                            child: Text(
                              Constants.next,
                              style: TextStyle(
                                fontFamily: Constants.openSans,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pushNamed(context, SignupScreen.routeName);
                    //   },
                    //   child: Align(
                    //     alignment: Alignment.bottomLeft,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                    //       child: Text(
                    //         Constants.SKIP,
                    //         style: TextStyle(
                    //           fontFamily: Constants.OPEN_SANS,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 14.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < sliderArrayList.length; i++)
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
}
