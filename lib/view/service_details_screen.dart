import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  static const String routeName = '/service_detail';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ServiceDetailScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Detail'),
      ),
    );
  }
}
