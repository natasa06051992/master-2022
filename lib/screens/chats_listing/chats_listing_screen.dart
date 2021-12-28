import 'package:flutter/material.dart';

class ChatsListingScreen extends StatelessWidget {
  static const String routeName = '/chats_listing';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ChatsListingScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
    );
  }
}
