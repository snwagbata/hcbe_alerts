import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// Returns a FlushBar with the message passed into it.
/// 
/// Parameters:
/// 
///  • `String message` - Message that will be displayed in the FlushBar.
/// 
///  • `int secDuration` - How much time the FlushBar is displayed in seconds.
/// 
///  • `BuildContext context` - Takes the current build context.
Widget bar(String message, int secDuration, BuildContext context) {
  return Flushbar(
    message: message,
    duration: Duration(seconds: secDuration),
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.all(8),
    borderRadius: 5,
  )..show(context);
}
