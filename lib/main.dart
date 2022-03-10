import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print(" --- background message received ---");
  print(message.notification!.title);
  print(message.notification!.body);
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServices();
  setupFCM();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
void setupFCM() {
  loadFCM();
  listenFCM();
}

void listenFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
            icon: 'launch_background',
          ),
        ),
      );
      // Navigator.pushNamed(context, ReviewsScreen.routeName,
      //     arguments: locator.get<UserController>().currentUser);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
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
            icon: 'launch_background',
          ),
        ),
      );
    }
    // Navigator.pushNamed(context, ReviewsScreen.routeName,
    //     arguments: locator.get<UserController>().currentUser);
  });
}

void loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
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
        initialRoute: OnBoardingScreen.routeName,
        onGenerateRoute: AppRouter.onGenerateRoute,
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
