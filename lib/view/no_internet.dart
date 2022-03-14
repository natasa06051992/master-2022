import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  static const String routeName = '/no_internet';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const NoInternetScreen(),
        settings: const RouteSettings(name: routeName));
  }

  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Nema interneta'),
        ),
        body: const Center(
            child: Text(
          'Nema interneta',
          style: TextStyle(fontSize: 24),
        )));
  }
}
