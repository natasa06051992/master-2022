import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/profile_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import '../view/customers_projects_screen.dart';
import '../view/home_customer_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String title) {
  return AppBar(actions: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
            ),
            GestureDetector(
                onTap: () {
                  if (locator.get<UserController>().currentUser
                      is CustomerModel) {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        HomeCustomerScreen.routeName,
                        (Route<dynamic> route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        CustomersProjects.routeName,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Image.asset("assets/veleMajstor.png", width: 150)),
          ],
        ),
      ],
    ),
    const SizedBox(
      width: 120,
    ),
    IconButton(
        onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
        icon: const Icon(Icons.person)),
  ]);
}
