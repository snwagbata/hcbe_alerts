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

  /// fire() method will get `String schoolId` and change alert type of school based on `String alertType`
  /// update db based on schoolId first
  /// then get location and everything required to create an alert object
  /// create alert object then create new alert under alert collection in db
  static fire(String schoolId, String alertType) {}

  /// Updates current active alert with message. Only works when current school alert is not `green`
  /// 
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
