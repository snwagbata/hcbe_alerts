import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts {
  static checkActiveAlerts() {}

  /// fire() method will get `String schoolId` and change alert type of school based on `String alertType`
  /// update db based on schoolId first
  /// then get location and everything required to create an alert object
  /// create alert object then create new alert under alert collection in db
  /// cloud function will check for new alerts and send a notification to users in the school
  static fire(String schoolId, String alertType, String userId) async {
    Firestore.instance
        .document("schools/$schoolId")
        .updateData({"schoolAlertState": alertType, "schoolAlertActive": true});
    // get location and other prerequisites needed for the Distress object

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _alertMessage;
    if (prefs.getString('alertMessage') != null) {
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
      GeoPoint location;
      try {
        location = await _getLocation();
      } catch (e) {
        //if analytics is ever used. here is one place to use it
      }
      //update alert id, location, and timestamp
      Firestore.instance
          .collection("alerts")
          .document(docRef.documentID)
          .updateData({
        "location": location,
        "alertId": docRef.documentID,
        "timestamp": FieldValue.serverTimestamp(),
      });
      Firestore.instance
          .collection("schools")
          .document(schoolId)
          .updateData({"curAlertId": docRef.documentID});
    });

    await prefs.setString('alertMessage', "");
  }

  /// Get location, return null if access denied
  static Future<GeoPoint> _getLocation() async {
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

  /// Updates current active alert with message. Only works when current school alert is not `green`
  ///
  static void updateAlertMessages(String message, String alertId) {} 

  ///
  ///
  static void goGreen(String schoolId, String alertId) async {
    //update school's field values
    Firestore.instance.document("schools/$schoolId").updateData(
      {
        "schoolAlertState": "green",
        "schoolAlertActive": false,
        "curAlertId": "",
      },
    );

//update current alert field to mark it as resolved
    var timeResolved = DateTime.now();
    Firestore.instance.collection("alerts").document(alertId).updateData(
      {
        "alertActive": false,
        "timeResolved": timeResolved,
      },
    );
  }
}
