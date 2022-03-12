import 'package:flutter/material.dart';
import 'package:flutter_master/view/welcome_screen.dart';

import 'screens.dart';

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/onboarding.png'))),
            ),
            Text('Find local professionals!',
                style: Theme.of(context).textTheme.headline3),
            Text('Have you used VeleMajstor?',
                style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 50,
            ),
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
                Navigator.pushNamed(context, WelcomeScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
