import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/screens/screens.dart';
import 'package:provider/provider.dart';

import 'config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [BlocProvider(create: (_) => AuthCubit())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        initialRoute: LoginScreen.routeName,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
