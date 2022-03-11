import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:provider/provider.dart';

import 'config/app_router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServices();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        initialRoute: OnBoardingScreen.routeName,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: navigatorKey,
        home: StreamBuilder(
            stream: locator.get<AuthCubit>().firebaseAuth.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return FutureBuilder(
                    future: locator
                        .get<UserController>()
                        .getUser((userSnapshot.data as User).uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          var userModel = snapshot.data['role'] == 'Customer'
                              ? CustomerModel.fromDocumentSnapshot(
                                  snapshot.data)
                              : HandymanModel.fromDocumentSnapshot(
                                  snapshot.data);
                          locator.get<UserController>().initUser(userModel);

                          if (userModel is HandymanModel) {
                            return CustomersProjects();
                          } else {
                            return HomeCustomerScreen();
                          }
                        }
                      }
                      return OnBoardingScreen();
                    });
              } else {
                return OnBoardingScreen();
              }
            }),
      ),
    );
  }
}
