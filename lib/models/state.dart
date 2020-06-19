import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:hcbe_alerts/models/settings.dart';
import 'package:hcbe_alerts/models/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;
  Distress distress;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
    this.distress,
  });
}
