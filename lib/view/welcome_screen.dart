import 'package:flutter/material.dart';
import 'package:flutter_master/view/slider_layout_view.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/Welcome';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => WelcomeScreen(),
        settings: RouteSettings(name: routeName));
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

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}
