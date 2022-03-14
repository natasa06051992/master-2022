import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/customButton.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'screens.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return LoginScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool isObscure = true;

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulogujte se'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginError ||
              state is AuthGoogleError ||
              state is AuthFBError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage!),
              ));
            Navigator.push(context, SignupScreen.route());
          } else if (state is AuthLoginSuccess ||
              state is AuthGoogleSuccess ||
              state is AuthFBSuccess) {
            formKey.currentState!.reset();
            if (locator.get<UserController>().currentUser is CustomerModel) {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeCustomerScreen.routeName,
                  (Route<dynamic> route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context,
                  CustomersProjects.routeName, (Route<dynamic> route) => false);
            }
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
                        height: 120,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: FormBuilderTextField(
                            name: 'email',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.email(context,
                                  errorText: "Unesite validni email")
                            ]),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                contentPadding: const EdgeInsets.all(8),
                                hintText: "email",
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
                            obscureText: isObscure,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                contentPadding: const EdgeInsets.all(8),
                                hintText: "lozinka",
                                fillColor: Colors.grey[200],
                                suffixIcon: InkWell(
                                  child: Icon(isObscure
                                      ? Icons.radio_button_off
                                      : Icons.radio_button_checked),
                                  onTap: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                )),
                            textInputAction: TextInputAction.done,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      LoginButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final authCubit =
                                BlocProvider.of<AuthCubit>(context);
                            await authCubit.login(
                                formKey.currentState!.fields['email']!.value,
                                formKey
                                    .currentState!.fields['password']!.value);
                          }
                        },
                      ),
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName),
                          child: const Text("Lozinka zaboravljena?")),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.0,
                            width: 120.0,
                            child: RaisedButton.icon(
                              label: Text(
                                'Google',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              icon: Image.asset("assets/google_plus.png",
                                  width: 24.0, height: 24.0),
                              onPressed: () async {
                                final authCubit =
                                    BlocProvider.of<AuthCubit>(context);
                                await authCubit.googleAuth();
                              },
                              color: primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50.0,
                            width: 130.0,
                            child: RaisedButton.icon(
                              label: const Text(
                                'Facebook',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              icon: Image.asset("assets/facebook.png",
                                  width: 24.0, height: 24.0),
                              onPressed: () async {
                                final authCubit =
                                    BlocProvider.of<AuthCubit>(context);
                                await authCubit.googleAuth();
                              },
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Function onPressed;
  const LoginButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        child: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoginLoading) {
                return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ));
              } else {
                return const Text('Ulogujte se');
              }
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
