// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_master/cubit/push_notification_service.dart';
// import 'package:flutter_master/locator.dart';
// import 'package:flutter_master/view_controller/user_controller.dart';

// class DemoPage extends StatefulWidget {
//   static const String routeName = '/demo';

//   static Route route() {
//     return MaterialPageRoute(
//         builder: (_) => DemoPage(), settings: RouteSettings(name: routeName));
//   }

//   @override
//   _DemoPageState createState() => _DemoPageState();
// }

// class _DemoPageState extends State<DemoPage> {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final TextEditingController _textController = TextEditingController();
//   final CollectionReference _tokensDB =
//       FirebaseFirestore.instance.collection('users');
//   final FCMNotificationService _fcmNotificationService =
//       FCMNotificationService();

//   late String _otherDeviceToken;

//   @override
//   void initState() {
//     super.initState();

//     //Subscribe to the NEWS topic.
//     // _fcmNotificationService.subscribeToTopic(topic: 'NEWS');

//     load();
//   }

//   Future<void> load() async {
//     //Fetch the fcm token for this device.
//     String? token = await _fcm.getToken();

//     //Validate that it's not null.
//     assert(token != null);

//     //Update fcm token for this device in firebase.
//     DocumentReference docRef =
//         _tokensDB.doc(locator.get<UserController>().currentUser!.uid);
//     docRef.update({'token': token});

//     //Fetch the fcm token for the other device.
//     var docSnapshot = await _tokensDB
//         .where("email",
//             isNotEqualTo: locator.get<UserController>().currentUser!.email)
//         .get();
//     _otherDeviceToken =
//         'dkqBn6VER1KmJeEMm3Ei9M:APA91bHoMNyW1OaHKXScKjSo3EL6OjBWEBDNMj7TAstWxuNlId3LdAKNI18olgw8qt7-JZvxR0H4vuu81lN_3vX4lP6VaPDKCI8WrF72vuA3f69YEr5sURHPOr-M6sZrebaCmawO1E5e';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: TextField(
//                 controller: _textController,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.send),
//                   label: Text('Send Notification'),
//                   onPressed: () async {
//                     await _fcmNotificationService.sendNotificationToUser(
//                       title: 'New Notification!',
//                       body: _textController.text,
//                       fcmToken: _otherDeviceToken,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
