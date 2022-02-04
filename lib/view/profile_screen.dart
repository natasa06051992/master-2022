import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/avatar.dart';
import 'package:flutter_master/widgets/informations_user_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'screens.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ProfileScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _currentUser = locator.get<UserController>().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Avatar(
                          avatarUrl: _currentUser!.avatarUrl ?? null,
                          onTap: () async {
                            var image = (await ImagePicker()
                                .getImage(source: ImageSource.gallery));
                            if (image != null) {
                              locator
                                  .get<UserController>()
                                  .uploadProfilePicture(File(image.path));
                              setState(() {});
                            }
                          },
                        ),
                        Text(
                            "Hi ${_currentUser!.displayName ?? 'nice to see you here.'}"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InformationsAboutUserWidget(_currentUser!)))
            ]));
  }
}
