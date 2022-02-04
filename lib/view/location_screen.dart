import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import 'screens.dart';

class LocationScreen extends StatefulWidget {
  static const String routeName = '/location';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => LocationScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

final List<String> _locations = ['Novi Sad', 'Beograd', 'Nis', 'Vrsac'];
String _selectedLocation = 'Novi Sad';

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Column(children: [
        Text('What is your location?',
            style: Theme.of(context).textTheme.headline3),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
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
            )),
        ElevatedButton(
          onPressed: () {
            //   locator.get<UserController>().setLocation(_selectedLocation);
            Navigator.pushNamed(context, RoleScreen.routeName);
          },
          child: const Text("Next"),
        ),
      ]),
    );
  }
}
