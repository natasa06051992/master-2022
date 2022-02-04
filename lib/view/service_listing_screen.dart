import 'package:flutter/material.dart';

class ServiceListingScreen extends StatelessWidget {
  static const String routeName = '/service_listing';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ServiceListingScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service listing'),
      ),
    );
  }
}
