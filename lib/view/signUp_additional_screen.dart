import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/no_internet.dart';

import '../view_controller/user_controller.dart';

class SignUpAdditionalScreen extends StatefulWidget {
  static const String routeName = '/additional';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return SignUpAdditionalScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<SignUpAdditionalScreen> createState() => _SignUpAdditionalScreenState();
}

class _SignUpAdditionalScreenState extends State<SignUpAdditionalScreen> {
  String _selectedLocation = Constants.locations[0];
  String _selectedRole = Constants.role[0];
  bool isObscurePassword = true;
  String _selectedService = Constants.services[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Napravi nalog'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Icon(Icons.pin_drop),
                const SizedBox(
                  width: 15,
                ),
                DropdownButton(
                  hint: const Text(
                      'Izaberi lokaciju'), // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLocation = newValue.toString();
                    });
                  },
                  items: Constants.locations.map((location) {
                    return DropdownMenuItem(
                      child: Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Icon(Icons.handyman),
                const SizedBox(
                  width: 15,
                ),
                DropdownButton(
                  value: _selectedRole,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue.toString();
                    });
                  },
                  items: Constants.role.map((role) {
                    return DropdownMenuItem(
                      child: Text(role),
                      value: role,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (_selectedRole.contains(Constants.role[0]))
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(Icons.room_service),
                  const SizedBox(
                    width: 15,
                  ),
                  DropdownButton(
                    value: _selectedService,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedService = newValue.toString();
                      });
                    },
                    items: Constants.services.map((service) {
                      return DropdownMenuItem(
                        child: Text(service),
                        value: service,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
