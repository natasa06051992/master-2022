import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/screens/login/login_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String title) {
  return AppBar(title: Text(title), actions: [
    BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is AuthLoginError || state is AuthGoogleError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(state.errorMessage!),
          ));
      } else if (state is AuthLoginSuccess ||
          state is AuthGoogleSuccess ||
          state is AuthDefault) {
        Navigator.pushNamed(context, '/home');
      }
    }, builder: (context, state) {
      return GestureDetector(
        onTap: () async {
          if (state is AuthDefault || state is AuthGoogleSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.googleLogout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
            Navigator.pushNamed(context, LoginScreen.routeName);
          } else if (state is AuthLoginSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.logout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
            Navigator.pushNamed(context, LoginScreen.routeName);
          } else if (state is AuthFBSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.fbLogout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
            Navigator.pushNamed(context, LoginScreen.routeName);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Text('Logout'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.exit_to_app),
              ],
            )),
      );
    })
  ]);
}
