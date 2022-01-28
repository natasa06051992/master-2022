import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/widgets/customButton.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => SignupScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

bool isObscurePassword = true;

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
            if (state is AuthSignUpError ||
                state is AuthGoogleError ||
                state is AuthFBError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.errorMessage!),
                ));
            } else if (state is AuthSignUpSuccess ||
                state is AuthGoogleSuccess ||
                state is AuthFBSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text("Account successfully created!"),
                ));
              formKey.currentState!.reset();
              Navigator.pushNamed(context, '/location');
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
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.min(context, 2,
                                    errorText:
                                        "Name should have at least 2 letters!")
                              ]),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person),
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: "Enter name",
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
                              obscureText: isObscurePassword,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: "Enter password",
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
                                  formKey.currentState!.fields['email']!.value);
                            }
                          },
                        ),
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
                return const Text('Create acount');
              }
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
