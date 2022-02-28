import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import 'home_customer_screen.dart';

class AddNewProjectScreen extends StatefulWidget {
  static const String routeName = '/add_project';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => AddNewProjectScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  String _selectedService = Constants.services[0];
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  @override
  void initState() {
    _titleController.text = "";
    _descriptionController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: SafeArea(
        child: FormBuilder(
          autovalidateMode: AutovalidateMode.disabled,
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "title"),
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                DropdownButton(
                  hint: const Text(
                      'Please choose a service'), // Not necessary for Option 1
                  value: _selectedService,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedService = newValue.toString();
                    });
                  },
                  items: Constants.services.map((_selectedService) {
                    return DropdownMenuItem(
                      child: Text(_selectedService),
                      value: _selectedService,
                    );
                  }).toList(),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(hintText: "description"),
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String title = _titleController.text;
                      locator.get<UserController>().addNewProject(
                          _selectedService, _descriptionController.text, title);

                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeCustomerScreen.routeName,
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
