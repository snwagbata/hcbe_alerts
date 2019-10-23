import 'package:flutter/material.dart';

class Alert {
  /// Creates a [Alert] with the specified error [code] and optional
  /// [message], and with the optional error [details] which must be a valid
  /// value for the [MethodCodec] involved in the interaction.
  UserException({
    @required this.schoolId,
    @required this.alertType
    @required this.
    this.message,
    this.details,
  }) : assert(schoolId != null);

  /// An error code.
  final String schoolId;

  /// A human-readable error message, possibly null.
  final String message;

  /// Error details, possibly null.
  final dynamic details;

  @override
  String toString() => 'UserException($code, $message, $details)';
}
