import 'package:flutter/material.dart';

class Distress {
  /// Creates a [Distress] with the specified error [code] and optional
  /// [message], and with the optional error [details] which must be a valid
  /// value for the [MethodCodec] involved in the interaction.
  Distress({
    @required this.active,
    @required this.distressId,
    @required this.schoolId,
    @required this.distressCode,
    @required this.position,
    this.message,
  }) : assert(schoolId != null && distressCode != null);

  /// Status of the alert
  final bool active;

  /// Status of the alert
  final String distressId;

  /// An school code.
  final String schoolId;

  /// Distress type, ex: red, yellow.
  final String distressCode;

  /// A message to explain situation, possibly null.
  final String message;

  /// Device location of user
  final dynamic position;


  @override
  String toString() => 'Distress($schoolId, $message,)';
}
