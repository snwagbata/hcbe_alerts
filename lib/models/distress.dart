import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Distress alertFromJson(String str) {
  final jsonData = json.decode(str);
  return Distress.fromJson(jsonData);
}

String userToJson(Distress data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Distress {
  /// Status of the alert
  final bool active;

  /// Id of user who triggered the alert
  final String triggeredBy;

  /// Status of the alert
  final String distressId;

  /// An school code.
  final String schoolId;

  /// Distress type, ex: red, yellow.
  final String distressType;

  /// A message to explain situation, possibly null.
  String message;

  /// Device location of user
  final GeoPoint location;

  /// Current time
  final dynamic timeTriggered; //= new DateTime.now(); <--- Call that when implementing it in home screen
  
  /// Time Distress was resolved
  final dynamic timeResolved;
    /// Creates a [Distress] with the specified error [code] and optional
  /// [message], and with the optional error [details] which must be a valid
  /// value for the [MethodCodec] involved in the interaction.
  Distress({
    @required this.active,
    @required this.triggeredBy,
    @required this.distressId,
    @required this.distressType,
    @required this.schoolId,
    @required this.timeTriggered,
    this.timeResolved,
    this.location,
    this.message,
    
  }) : assert(schoolId != null && distressType != null && triggeredBy != null);


  factory Distress.fromJson(Map<String, dynamic> json) => new Distress(
        active: json["alertActive"],
        triggeredBy: json["triggeredBy"],
        distressId: json["alertId"],
        distressType: json["alertType"],
        schoolId: json["schoolId"],
        message: json["message"],
        timeTriggered: json["timetriggered"],
        timeResolved: json["timeResolved"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
    "alertActive" : active,
    "triggeredBy" : triggeredBy,
    "alertId" : distressId,
    "alertType" : distressType,
    "schoolId" : schoolId,
    "message" : message,
    "timetriggered" : timeTriggered,
    "timeResolved" : timeResolved,
    "location" : location 
      };


  factory Distress.fromDocument(DocumentSnapshot doc) {
    return Distress.fromJson(doc.data);
  }

  @override
  String toString() => 'New $distressType at $schoolId. Message: $message. Location: ${location.latitude}, ${location.longitude}';
}
