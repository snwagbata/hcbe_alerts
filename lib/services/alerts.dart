import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/models/user.dart';
import 'package:hcbe_alerts/services/firebase.dart';
import 'package:hcbe_alerts/services/state_widget.dart';

class Alerts {
  static Future<String> getCurrentAlert(String schoolId) async {
    String curCode = "";
    var doc = await Firestore.instance.document("schools/$schoolId").get();
    curCode = doc.data["schoolAlertState"];
    return curCode;
  }

  static Future<String> getCurrentAlertName(String schoolId) async {
    String curCode = "";
    var doc = await Firestore.instance.document("schools/$schoolId").get();
    curCode = doc.data["schoolAlertState"];

    switch (curCode) {
      case "red":
        return "Code Red";
        break;
      case "blue":
        return "Code Blue";
        break;
      case "intruder":
        return "Active Intruder";
        break;
      case "yellow":
        return "Code Yellow";
        break;
      default:
        return "Code Green";
    }
  }

  static checkActiveAlerts() {}
  static void fire(String alertType) {}

  static void updateAlert(String message) {}

  static Future<String> getAlertImgPath(String schoolId) async {
    String curCode = "";
    var doc = await Firestore.instance.document("schools/$schoolId").get();
    curCode = doc.data["schoolAlertState"];

    if (curCode == 'red') {
      return 'assets/code_red.png';
    }
    return "assets/code_green.png";
  }
}
