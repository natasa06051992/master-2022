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
        body: Center(
            child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/noInternet.jpg'))),
            ),
            Text(
              'Nema interneta',
              style: TextStyle(fontSize: 24),
            ),
          ],
        )));
  }
}
