import 'dart:async';
import 'dart:convert' show json;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_master/view/reviews_screen.dart';
import 'package:http/http.dart' as http;

class FCMNotificationService extends StatefulWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAArRJjr4s:APA91bEYbi_NBZudDayuRAYbQmXmT2NJwm1S1nR5MlqOSHGlik9i9Ho0sNiED1pLz_JVoRgF7G7tFOQSlQQ4U4yu0LMj3T9PKXkscbON7Ck-wiumzZiIKx8QS5DBD8EOBqFjeqE_3qdG';
  FCMNotificationService({Key? key}) : super(key: key);
  void sendNotificationToSpecificUser(
      String title, String body, String token) async {
    await sendNotificationToUser(
      title: title,
      body: body,
      fcmToken: token,
    );
  }

  Future<http.Response> _sendNotification(
    String to,
    String title,
    String body,
  ) async {
    try {
      final dynamic data = json.encode(
        {
          'to': to,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
          },
          'content_available': true
        },
      );
      http.Response response = await http.post(
        Uri.parse(_endpoint),
        body: data,
        headers: {
          'Content-Type': _contentType,
          'Authorization': _authorization
        },
      );

      return response;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> sendNotificationToUser({
    required String fcmToken,
    required String title,
    required String body,
  }) {
    return _sendNotification(
      fcmToken,
      title,
      body,
    );
  }

  @override
  State<FCMNotificationService> createState() => _FCMNotificationServiceState();
}

class _FCMNotificationServiceState extends State<FCMNotificationService> {
  @override
  void initState() {
    var channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        widget.flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
        Navigator.pushNamed(context, ReviewsScreen.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class FCMNotificationServiceee  {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
//   final String _contentType = 'application/json';
//   final String _authorization =
//       'key=AAAArRJjr4s:APA91bEYbi_NBZudDayuRAYbQmXmT2NJwm1S1nR5MlqOSHGlik9i9Ho0sNiED1pLz_JVoRgF7G7tFOQSlQQ4U4yu0LMj3T9PKXkscbON7Ck-wiumzZiIKx8QS5DBD8EOBqFjeqE_3qdG';
//   FCMNotificationService() {
  
//   }

//   @override
//   Future<void> unsubscribeFromTopic({required String topic}) {
//     return _firebaseMessaging.unsubscribeFromTopic(topic);
//   }

//   @override
//   Future<void> subscribeToTopic({required String topic}) {
//     return _firebaseMessaging.subscribeToTopic(topic);
//   }

//   @override
 

//   @override
//   Future<void> sendNotificationToGroup(
//       {required String group, required String title, required String body}) {
//     return _sendNotification('/topics/' + group, title, body);
//   }
// }
