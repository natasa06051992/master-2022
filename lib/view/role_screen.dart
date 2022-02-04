import 'package:flutter/material.dart';
import 'package:flutter_master/cubit/firebase_firestore_repo.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'screens.dart';

class RoleScreen extends StatelessWidget {
  static const String routeName = '/role';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => RoleScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Role')),
      body: Column(
        children: [
          Text('Are you hiring or looking for a job?',
              style: Theme.of(context).textTheme.headline3),
          ElevatedButton(
            onPressed: () {
              locator.get<UserController>().currentUser as CustomerModel;

              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,
                  (Route<dynamic> route) => false);
            },
            child: const Text("Hiring"),
          ),
          ElevatedButton(
            onPressed: () {
              locator.get<UserController>().currentUser as HandymanModel;
              Navigator.pushNamed(context, ChooseServiceScreen.routeName);
            },
            child: const Text("Looking for a job!"),
          ),
        ],
      ),
    );
  }
}
