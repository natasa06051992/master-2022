import 'package:flutter/material.dart';
import 'package:flutter_master/widgets/widgets.dart';

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

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Column(children: [
        LocationDropBox(),
        SaveButton(),
      ]),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      top: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0),
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
          child: Text('Save'),
          onPressed: () {
            //add location to user
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
    );
  }
}
