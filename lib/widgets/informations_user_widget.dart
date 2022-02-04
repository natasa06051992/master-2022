import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

class InformationsAboutUserWidget extends StatefulWidget {
  final UserModel currentUser;
  const InformationsAboutUserWidget(
    this.currentUser,
  );

  @override
  State<InformationsAboutUserWidget> createState() =>
      _InformationsAboutUserWidgetState();
}

final List<String> _locations = ['Novi Sad', 'Beograd', 'Nis', 'Vrsac'];
String _selectedLocation = 'Novi Sad';

class _InformationsAboutUserWidgetState
    extends State<InformationsAboutUserWidget> {
  var _displayNameController = TextEditingController();
  var _phoneNumberController = TextEditingController();

  var _serviceController = TextEditingController();
  @override
  void initState() {
    _displayNameController.text = widget.currentUser.displayName!;
    _phoneNumberController.text = widget.currentUser.phoneNumber ?? "";

    if (widget.currentUser is HandymanModel) {
      _serviceController.text =
          (widget.currentUser as HandymanModel).service ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        TextFormField(
          decoration: InputDecoration(hintText: "Username"),
          controller: _displayNameController,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Phone number"),
          controller: _phoneNumberController,
        ),
        DropdownButton(
          hint: const Text(
              'Please choose a location'), // Not necessary for Option 1
          value: _selectedLocation,
          onChanged: (newValue) {
            setState(() {
              _selectedLocation = newValue.toString();
            });
          },
          items: _locations.map((location) {
            return DropdownMenuItem(
              child: Text(location),
              value: location,
            );
          }).toList(),
        ),
        if (widget.currentUser is HandymanModel)
          TextFormField(
            decoration: InputDecoration(hintText: "Service"),
            controller: _serviceController,
          ),
        if (widget.currentUser is CustomerModel)
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, CustomersProjects.routeName),
              child: Text('My Projects')),
        SizedBox(height: 20.0),
        BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
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
                    if (state is AuthDefault || state is AuthGoogleSuccess) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.googleLogout();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text("Logout was successuful"),
                        ));
                    } else if (state is AuthLoginSuccess ||
                        state is AuthSignUpSuccess) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.logout();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text("Logout was successuful"),
                        ));
                    } else if (state is AuthFBSuccess) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.fbLogout();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text("Logout was successuful"),
                        ));
                    }

                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        OnBoardingScreen.routeName,
                        (Route<dynamic> route) => false);
                  },
                )
              ]);
        }),
        RaisedButton(
          onPressed: () {
            if (_displayNameController.text != widget.currentUser.displayName) {
              locator
                  .get<UserController>()
                  .updateDisplayName(_displayNameController.text);
            }
            if (_phoneNumberController.text != widget.currentUser.phoneNumber) {
              locator
                  .get<UserController>()
                  .updatePhoneNumber(_phoneNumberController.text);
            }
            if (_selectedLocation != widget.currentUser.location) {
              locator.get<UserController>().updateLocation(_selectedLocation);
            }
            if (widget.currentUser is HandymanModel &&
                _serviceController.text !=
                    (widget.currentUser as HandymanModel).service) {
              locator
                  .get<UserController>()
                  .updateService(_serviceController.text);
            }

            Navigator.pop(context);
          },
          child: Text("Save Profile"),
        )
      ]),
    );
  }
}
