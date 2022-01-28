import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/screens/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/avatar.dart';

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
  UserModel _currentUser = locator.get<UserController>().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
            Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Avatar(
                    avatarUrl: _currentUser.avatarUrl,
                    onTap: () {},
                  ),
                  Text(
                      "Hi ${_currentUser.displayName ?? 'nice to see you here.'}"),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Username"),
                    ),
                    SizedBox(height: 20.0),
                    BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                      if (state is AuthLoginError || state is AuthGoogleError) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(state.errorMessage!),
                          ));
                      } else if (state is AuthLoginSuccess ||
                          state is AuthGoogleSuccess ||
                          state is AuthDefault) {
                        Navigator.pushNamed(context, '/home');
                      }
                    }, builder: (context, state) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.exit_to_app),
                              label: Text('Logout'),
                              onPressed: () async {
                                if (state is AuthDefault ||
                                    state is AuthGoogleSuccess) {
                                  final authCubit =
                                      BlocProvider.of<AuthCubit>(context);
                                  await authCubit.googleLogout();
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content: Text("Logout was successuful"),
                                    ));
                                } else if (state is AuthLoginSuccess) {
                                  final authCubit =
                                      BlocProvider.of<AuthCubit>(context);
                                  await authCubit.logout();
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content: Text("Logout was successuful"),
                                    ));
                                } else if (state is AuthFBSuccess) {
                                  final authCubit =
                                      BlocProvider.of<AuthCubit>(context);
                                  await authCubit.fbLogout();
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content: Text("Logout was successuful"),
                                    ));
                                }
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginScreen.routeName,
                                    (Route<dynamic> route) => false);
                              },
                            )
                          ]);
                    }),
                    RaisedButton(
                      onPressed: () {
                        // TODO: Save somehow
                        Navigator.pop(context);
                      },
                      child: Text("Save Profile"),
                    )
                  ])))
        ]));
  }
}
