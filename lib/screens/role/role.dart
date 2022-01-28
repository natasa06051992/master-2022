import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/screens/choose_service/choose_service_screen.dart';
import 'package:flutter_master/screens/home/home_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

class RoleScreen extends StatelessWidget {
  static const String routeName = '/role';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => RoleScreen(), settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Role')),
      body: Column(
        children: [
          Text('Are you hiring or looking for a job?',
              style: Theme.of(context).textTheme.headline3),
          ElevatedButton(
            onPressed: () {
              locator.get<UserController>().currentUser.setRole(false);
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,
                  (Route<dynamic> route) => false);
            },
            child: Text("Hiring"),
          ),
          ElevatedButton(
            onPressed: () {
              locator.get<UserController>().currentUser.setRole(true);
              Navigator.pushNamed(context, ChooseServiceScreen.routeName);
            },
            child: Text("Looking for a job!"),
          ),
        ],
      ),
    );
  }
}
