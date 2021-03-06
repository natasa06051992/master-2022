import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/services/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/customButton.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../config/constants.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return SignupScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

String _selectedLocation = Constants.locations[0];

String _selectedRole = Constants.role[0];
bool isObscurePassword = true;
String _selectedService = Constants.services[0];
bool isAlreadyCreatedAcount = false;

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.err!),
                ));
              Navigator.pushNamedAndRemoveUntil(context, SignupScreen.routeName,
                  (Route<dynamic> route) => false);
            } else if (state is AuthSignUpSuccess ||
                state is AuthGoogleSuccess ||
                state is AuthFBSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text("Uspe??no napravljen nalog!"),
                ));
              formKey.currentState!.reset();
              if (locator.get<UserController>().currentUser is CustomerModel) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomeCustomerScreen.routeName,
                    (Route<dynamic> route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    CustomersProjects.routeName,
                    (Route<dynamic> route) => false);
              }
            } else if (state is AuthGoogleError || state is AuthFBError) {
              isAlreadyCreatedAcount = true;
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: FormBuilder(
                autovalidateMode: AutovalidateMode.disabled,
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FormBuilderTextField(
                              name: 'name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Unesite ime';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person),
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: "Ime",
                                  fillColor: Colors.grey[200]),
                              textInputAction: TextInputAction.next,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FormBuilderTextField(
                              name: 'email',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.email(context,
                                    errorText: "Unesite validan email")
                              ]),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email),
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: "Email",
                                  fillColor: Colors.grey[200]),
                              textInputAction: TextInputAction.next,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FormBuilderTextField(
                              name: 'password',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Unesite lozinka';
                                }
                                return null;
                              },
                              obscureText: isObscurePassword,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: "Lozinka",
                                  fillColor: Colors.grey[200],
                                  suffixIcon: InkWell(
                                    child: Icon(isObscurePassword
                                        ? Icons.radio_button_off
                                        : Icons.radio_button_checked),
                                    onTap: () {
                                      setState(() {
                                        isObscurePassword = !isObscurePassword;
                                      });
                                    },
                                  )),
                              textInputAction: TextInputAction.done,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.pin_drop, color: Colors.grey[600]),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton(
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                                hint: const Text(
                                    'Unesite lokaciju'), // Not necessary for Option 1
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.handyman, color: Colors.grey[600]),
                                const SizedBox(
                                  width: 20,
                                ),
                                DropdownButton(
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                  value: _selectedRole,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedRole = newValue.toString();
                                    });
                                  },
                                  items: Constants.role.map((role) {
                                    String child = role;
                                    if (role == "Mu??terija") {
                                      child = "Tra??im majstora";
                                    }
                                    return DropdownMenuItem(
                                      child: Text(child),
                                      value: role,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedRole.contains(Constants.role[0]))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(Icons.room_service,
                                      color: Colors.grey[600]),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 16),
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
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        SignUpButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final authCubit =
                                  BlocProvider.of<AuthCubit>(context);
                              await authCubit.signUp(
                                  formKey.currentState!.fields['name']!.value,
                                  formKey
                                      .currentState!.fields['password']!.value,
                                  formKey.currentState!.fields['email']!.value,
                                  _selectedLocation,
                                  _selectedRole,
                                  _selectedService,
                                  isAlreadyCreatedAcount);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

class SignUpButton extends StatelessWidget {
  final Function onPressed;
  const SignUpButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        child: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSignUpLoading) {
                return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ));
              } else {
                return const Text('Kreiranje naloga');
              }
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
