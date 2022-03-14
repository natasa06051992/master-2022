import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/welcome_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import 'screens.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return OnBoardingScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cao!')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/onboarding.png'))),
            ),
            Text('Tražite majstore?',
                style: Theme.of(context).textTheme.headline3),
            Text('Da li ste već koristili VeleMajstor-a?',
                style: Theme.of(context).textTheme.headline3),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: Text(
                'Da!',
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
                'Ne! Napraviću nalog',
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
