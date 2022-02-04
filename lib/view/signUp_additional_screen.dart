import 'package:flutter/material.dart';

class SignUpAdditionalScreen extends StatefulWidget {
  static const String routeName = '/additional';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => SignUpAdditionalScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<SignUpAdditionalScreen> createState() => _SignUpAdditionalScreenState();
}

class _SignUpAdditionalScreenState extends State<SignUpAdditionalScreen> {
  final List<String> _locations = ['Novi Sad', 'Beograd', 'Nis', 'Vrsac'];

  String _selectedLocation = 'Novi Sad';

  final List<String> _role = ['Handyman', 'Customer'];

  String _selectedRole = 'Customer';

  bool isObscurePassword = true;

  final List<String> _services = ['House cleaning', 'Handyman', 'Plumber'];

  String _selectedService = 'House cleaning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.pin_drop),
                SizedBox(
                  width: 15,
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
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.handyman),
                SizedBox(
                  width: 15,
                ),
                DropdownButton(
                  value: _selectedRole,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue.toString();
                    });
                  },
                  items: _role.map((role) {
                    return DropdownMenuItem(
                      child: Text(role),
                      value: role,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (_selectedRole.contains('Handyman'))
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.room_service),
                  SizedBox(
                    width: 15,
                  ),
                  DropdownButton(
                    value: _selectedService,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedService = newValue.toString();
                      });
                    },
                    items: _services.map((service) {
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
