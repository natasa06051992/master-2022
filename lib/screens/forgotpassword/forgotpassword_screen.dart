import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/widgets/customButton.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotpassword';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(),
        settings: RouteSettings(name: routeName));
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
          title: const Text('Forgot Password?'),
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
                content: Text("Reset link has been sent to your email!"),
                backgroundColor: Colors.white,
              ));
            Navigator.pushNamed(context, '/home');
          }
        }, builder: (context, state) {
          if (state is AuthForgotPasswordLoading) {
            return Center(child: const CircularProgressIndicator());
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
              return Text('Send link');
            },
            listener: (context, state) {}),
        onPressed: onPressed);
  }
}
