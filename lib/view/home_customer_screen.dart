import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/widgets/app_bar.dart';

class HomeCustomerScreen extends StatelessWidget {
  static const String routeName = '/home';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomeCustomerScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, 'Home'),
        body: Center(
            child: Card(
                child: SizedBox(
          child: ListView.builder(
            itemCount: Constants.services.length,
            itemBuilder: (context, i) {
              return InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.pushNamed(context, ServiceListingScreen.routeName,
                      arguments: Constants.services[i]);
                },
                child: ListTile(
                  title: Text("${Constants.services[i]}"),
                ),
              );
            },
          ),
        ))));
  }
}
