import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/cubit/connectivity.dart';
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

late AndroidNotificationChannel channel;
void setupFCM() {
  loadFCM();
  listenFCM();
}

Future<void> onSelectNotification(String? payload) async {
  print("onSelectNotification");
  if (locator.get<UserController>().currentUser is HandymanModel) {
    ScaffoldMessenger.of(Constants.navigatorKey.currentState!.context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Dobio si recenziju!'),
      ));

    Navigator.pushNamed(
        Constants.navigatorKey.currentState!.context, ReviewsScreen.routeName,
        arguments: locator.get<UserController>().currentUser);
  }
}

void listenFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    if (locator.get<UserController>().currentUser is CustomerModel) return;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (locator.get<UserController>().currentUser is CustomerModel) return;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
}

void loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_logo_handyman');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

Future<void> messageHandler() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupServices();
  setupFCM();
  await messageHandler();
  locator.get<UserController>().initCategories();
  runApp(MyApp());
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyApp extends StatelessWidget {
  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Velemajstor',
        theme: theme(),
        initialRoute: OnBoardingScreen.routeName,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: Constants.navigatorKey,
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
                          var userModel =
                              snapshot.data['role'] == Constants.role[1]
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
              } else if (!locator
                  .get<UserController>()
                  .checkForInternetConnection(ctx)) {
                return NoInternetScreen();
              } else {
                return OnBoardingScreen();
              }
            }),
      ),
    );
  }
}
