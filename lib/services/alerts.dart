import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts {
  /// Returns the school alert state
  static Future<String> getCurrentAlert(String schoolId) async {
    String curCode = "";
    var doc = await Firestore.instance.document("schools/$schoolId").get();
    curCode = doc.data["schoolAlertState"];
    return curCode;
  }

  static Future<String> getCurrentAlertName(String schoolId) async {
    String curCode = await getCurrentAlert(schoolId);

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
  static fire(String schoolId, String alertType, String userId) async {
    Firestore.instance
        .document("schools/$schoolId")
        .updateData({"schoolAlertState": alertType, "schoolAlertActive": true});
    // get location and other prerequisites needed for the Distress object

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _alertMessage;
    if (prefs.getString('settings') != null) {
      _alertMessage = prefs.getString('alertMessage');
    } else {
      _alertMessage = "";
    }

    Distress sendToDB = Distress(
      active: true,
      triggeredBy: userId,
      distressId: null,
      distressType: alertType,
      schoolId: schoolId,
      timeTriggered: new DateTime.now(),
      message: _alertMessage,
    );
    Firestore.instance
        .collection("alerts")
        .add(sendToDB.toJson())
        .then((docRef) async {
      //update location
      GeoPoint location = await _getLocation();
      Firestore.instance
          .collection("alerts")
          .document(docRef.documentID)
          .updateData({"location": location});

//send fcm to all users with schoolId
    });

    await prefs.setString('alertMessage', "");
  }

  /// Updates current active alert with message. Only works when current school alert is not `green`
  ///
  static void updateAlertMessages(String message) {}

  /// Get location, return null if access denied
  static Future<GeoPoint> _getLocation() async {
    //TODO: create new alert in db with loc off
    Location location = new Location();
    var pos = await location.getLocation();
    GeoPoint _curLoc;
    if (pos is Error) {
      _curLoc = null;
    } else {
      _curLoc = GeoPoint(pos.latitude, pos.longitude);
    }
    return _curLoc;
  }

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
