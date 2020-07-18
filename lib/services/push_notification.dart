import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static const _platform =
      const MethodChannel('safekul.healersoft.com/distress');

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true),
      );
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final code = message['notification']['title'];
        final alertMessage = message['notification']['body'];
        _platform.invokeMethod('distress', <String, dynamic>{
          'code': code,
          'message': alertMessage,
        });
        print("onMessage: $code");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future subscribeToNotification(String id) async {
    await _fcm.subscribeToTopic(id);
  }

  Future unsubscribeToNotification(String id) async {
    await _fcm.unsubscribeFromTopic(id);
  }
}
