import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/services/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/customButton.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'screens.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotpassword';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return ForgotPasswordScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Zaboravili ste lozinku?'),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
          if (state is AuthForgotPasswordError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.err!),
              ));
          } else if (state is AuthForgotPasswordSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Link j eposlat na email!"),
                backgroundColor: Colors.white,
              ));
            Navigator.pushNamed(context, '/login');
          }
        }, builder: (context, state) {
          if (state is AuthForgotPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
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
                            image:
                                AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
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
                                      errorText: "Unesite validni email")
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
                          SendLinkButton(onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final authCubit =
                                  BlocProvider.of<AuthCubit>(context);
                              await authCubit.forgotPassword(
                                  formKey.currentState!.fields['email']!.value);
                            }
                          })
                        ])))));
          }
        }));
  }
}

class SendLinkButton extends StatelessWidget {
  final Function onPressed;
  const SendLinkButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        child: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              return const Text('Poslati link');
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
