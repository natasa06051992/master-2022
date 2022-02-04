import 'package:flutter/material.dart';

class CustomersProjects extends StatelessWidget {
  static const String routeName = '/customers_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => CustomersProjects(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers Projects'),
      ),
    );
  }
}
