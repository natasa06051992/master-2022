import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

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
  String _selectedService = 'House cleaning';
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: FormBuilder(
        autovalidateMode: AutovalidateMode.disabled,
        key: formKey,
        child: Column(
          children: [
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FormBuilderTextField(
                    maxLines: 1,
                    name: 'title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Enter title",
                        fillColor: Colors.grey[200]),
                    textInputAction: TextInputAction.next,
                  )),
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FormBuilderTextField(
                    maxLines: 5,
                    name: 'description',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Enter description",
                        fillColor: Colors.grey[200]),
                    textInputAction: TextInputAction.next,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  locator.get<UserController>().addNewProject(
                      _selectedService,
                      formKey.currentState!.fields['description']!.value
                          .toString(),
                      formKey.currentState!.fields['title']!.value.toString());

                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
