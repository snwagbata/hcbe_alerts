import 'package:flutter/widgets.dart';

class UserException implements Exception {
  /// Creates a [PlatformException] with the specified error [code] and optional
  /// [message], and with the optional error [details] which must be a valid
  /// value for the [MethodCodec] involved in the interaction.
  UserException({
    @required this.code,
    this.message,
    this.details,
  }) : assert(code != null);

  /// An error code.
  final String code;

  /// A human-readable error message, possibly null.
  final String message;

  /// Error details, possibly null.
  final dynamic details;

  @override
  String toString() => 'UserException($code, $message, $details)';
}
