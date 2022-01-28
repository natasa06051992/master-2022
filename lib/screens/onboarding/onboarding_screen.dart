import 'package:flutter/material.dart';
import 'package:flutter_master/screens/screens.dart';
import 'package:flutter_master/screens/signup/signup_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => OnBoardingScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hi')),
      body: Column(
        children: [
          Text('Find local professionals!',
              style: Theme.of(context).textTheme.headline3),
          Text('Have you used VeleMajstor?',
              style: Theme.of(context).textTheme.headline3),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: Text(
              'Yes! Log in',
              style: Theme.of(context).textTheme.headline3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: Text(
              'No! Sign Up',
              style: Theme.of(context).textTheme.headline3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SignupScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
