import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal() {}

  Future sendPushMessage(String title, String body, String to) async {
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    await func.call(<String, dynamic>{
      "targetDevices": to,
      "messageTitle": title,
      "messageBody": body
    });
  }
}
