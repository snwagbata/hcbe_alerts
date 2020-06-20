import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true),
      );
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
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
