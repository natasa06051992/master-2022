import 'package:flutter/material.dart';
import 'package:flutter_master/view/slider_layout_view.dart';

import '../locator.dart';
import '../view_controller/user_controller.dart';
import 'no_internet.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/Welcome';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return WelcomeScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => SliderLayoutView();
}
