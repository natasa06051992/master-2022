import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/config/app_router.dart';
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
        builder: (_) => LoginScreen(),
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
        title: const Text('Login'),
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
                        height: 100,
                        width: 100,
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
                                  errorText: "Enter a valid email adress")
                            ]),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                contentPadding: const EdgeInsets.all(8),
                                hintText: "Enter email",
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
                                hintText: "Enter password",
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

                            // await locator.get<UserController>().login(
                            //     formKey.currentState!.fields['email']!.value,
                            //     formKey
                            //         .currentState!.fields['password']!.value);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName),
                          child: const Text("Forgot Password?")),
                      CustomButton(
                          child: Text('Google'),
                          onPressed: () async {
                            final authCubit =
                                BlocProvider.of<AuthCubit>(context);
                            await authCubit.googleAuth();
                          }),
                      CustomButton(
                          child: Text('Facebook'),
                          onPressed: () async {
                            final authCubit =
                                BlocProvider.of<AuthCubit>(context);
                            await authCubit.facebookAuth();
                          }),
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
                return const Text('Login');
              }
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
