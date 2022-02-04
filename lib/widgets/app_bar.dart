import 'package:flutter/material.dart';
import 'package:flutter_master/view/profile_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String title) {
  return AppBar(title: Text(title), actions: [
    IconButton(
        onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
        icon: Icon(Icons.person)),
  ]);
}
