import 'package:flutter/material.dart';

class Distress {
  /// Creates a [Distress] with the specified error [code] and optional
  /// [message], and with the optional error [details] which must be a valid
  /// value for the [MethodCodec] involved in the interaction.
  Distress({
    @required this.active,
    @required this.distressId,
    @required this.distressType,
    @required this.schoolId,
    @required this.location,
    this.message,
    @required this.time,
  }) : assert(schoolId != null && distressType != null);

  /// Status of the alert
  final bool active;

  /// Status of the alert
  final String distressId;

  /// An school code.
  final String schoolId;

  /// Distress type, ex: red, yellow.
  final String distressType;

  /// A message to explain situation, possibly null.
  final String message;

  /// Device location of user
  final dynamic location;

  /// Current time
  final var time; //= new DateTime.now(); <--- Call that when implementing it in home screen
  @override
  String toString() => 'Distress($schoolId, $message,)';
}
