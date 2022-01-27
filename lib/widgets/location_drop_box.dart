import 'package:flutter/material.dart';

class LocationDropBox extends StatefulWidget {
  const LocationDropBox({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationDropBox> createState() => _LocationDropBoxState();
}

class _LocationDropBoxState extends State<LocationDropBox> {
  final List<String> _locations = ['Novi Sad', 'Beograd', 'Nis', 'Vrsac'];
  String? _selectedLocation = 'Novi Sad';
  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ));
  }
}
