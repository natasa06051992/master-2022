import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/view/reviews_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import '../locator.dart';

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
    var res = await func.call(<String, dynamic>{
      "targetDevices": to,
      "messageTitle": title,
      "messageBody": body
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }
}
