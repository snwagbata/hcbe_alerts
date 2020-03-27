import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:intl/intl.dart';

class AlertDetail extends StatelessWidget {
  final Distress alertDetail;

  AlertDetail({this.alertDetail});
  _getDistressName(String db) {
    switch (db) {
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

  _getFormattedDate(DateTime now) {
    return DateFormat.yMd().add_jm().format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getDistressName(alertDetail.distressType)),
      ),
    );
  }
}
