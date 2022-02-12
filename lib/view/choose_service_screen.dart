import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'screens.dart';

class ChooseServiceScreen extends StatefulWidget {
  static const String routeName = '/choose_service';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ChooseServiceScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  String _selectedService = 'House cleaning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose service')),
      body: Column(children: [
        Text('Choose service:', style: Theme.of(context).textTheme.headline3),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              hint: const Text(
                  'Please choose a service'), // Not necessary for Option 1
              value: _selectedService,
              onChanged: (newValue) {
                setState(() {
                  _selectedService = newValue.toString();
                });
              },
              items: Constants.services.map((location) {
                return DropdownMenuItem(
                  child: Text(location),
                  value: location,
                );
              }).toList(),
            )),
        ElevatedButton(
          onPressed: () {
            //  locator.get<UserController>().setService(_selectedService);
            Navigator.pushNamed(context, RoleScreen.routeName);
          },
          child: Text("Next"),
        ),
      ]),
    );
  }
}
