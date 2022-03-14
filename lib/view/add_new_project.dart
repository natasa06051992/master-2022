import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/no_internet.dart';

import 'package:flutter_master/view_controller/user_controller.dart';

import 'home_customer_screen.dart';

class AddNewProjectScreen extends StatefulWidget {
  static const String routeName = '/add_project';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return AddNewProjectScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  String _selectedService = Constants.services[0];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dodati novi oglas'),
        ),
        body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return SafeArea(
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
                          decoration: const InputDecoration(hintText: "naslov"),
                          controller: _titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Obavezno polje je naslov';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    DropdownButton(
                      hint: const Text(
                          'Izaberite kategoriju'), // Not necessary for Option 1
                      value: _selectedService,
                      onChanged: (newValue) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          setState(() {
                            _selectedService = newValue.toString();
                          });
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
                          decoration: const InputDecoration(hintText: "opis"),
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Obavezno polje je opis';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String title = _titleController.text;
                          locator.get<UserController>().addNewProject(
                              _selectedService,
                              _descriptionController.text,
                              title);

                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeCustomerScreen.routeName,
                              (Route<dynamic> route) => false);
                        }
                      },
                      child: const Text('Sačuvaj'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
