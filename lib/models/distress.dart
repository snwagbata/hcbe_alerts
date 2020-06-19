import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Distress {
  /// Status of the alert
  final bool active;

  /// Id of user who triggered the alert
  final String triggeredBy;

  /// Status of the alert
  final String distressId;

  /// School code.
  final String schoolId;

  /// Distress type, ex: red, yellow.
  final String distressType;

  /// Device location of user
  final GeoPoint location;

  /// Current time
  final dynamic
      timeTriggered; //= new DateTime.now(); <--- Call that when implementing it in home screen

  /// Time Distress was resolved
  final dynamic timeResolved;

  Distress({
    @required this.active,
    @required this.triggeredBy,
    @required this.distressId,
    @required this.distressType,
    @required this.schoolId,
    @required this.timeTriggered,
    this.timeResolved,
    this.location,
  }) : assert(schoolId != null && distressType != null && triggeredBy != null);

  factory Distress.fromJson(Map<String, dynamic> json) => Distress(
        active: json["alertActive"],
        triggeredBy: json["triggeredBy"],
        distressId: json["alertId"],
        distressType: json["alertType"],
        schoolId: json["schoolId"],
        timeTriggered: json["timetriggered"],
        timeResolved: json["timeResolved"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "alertActive": active,
        "triggeredBy": triggeredBy,
        "alertId": distressId,
        "alertType": distressType,
        "schoolId": schoolId,
        "timetriggered": timeTriggered,
        "timeResolved": timeResolved,
        "location": location
      };

  factory Distress.fromDocument(DocumentSnapshot doc) {
    return Distress.fromJson(doc.data);
  }

  @override
  String toString() =>
      'New $distressType at $schoolId. Location: ${location.latitude}, ${location.longitude}';
}
