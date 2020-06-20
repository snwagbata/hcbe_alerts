import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:hcbe_alerts/ui/alert_detail_ui.dart';
import 'package:intl/intl.dart';

import 'alert_detail_chip.dart';

class AlertCard extends StatelessWidget {
  final Distress alertDetails;

  AlertCard({this.alertDetails});
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AlertDetail(alertDetail: alertDetails),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _getDistressName(alertDetails.distressType),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Divider(),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: -8.0,
                      children: <Widget>[
                        AlertDetailChip(
                          Icons.event,
                          "Activated: ${_getFormattedDate(alertDetails.timeTriggered.toDate())}",
                        ),
                        if (!alertDetails.active)
                          AlertDetailChip(
                            Icons.event_available,
                            'Resolved: ${_getFormattedDate(alertDetails.timeResolved.toDate())}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          alertDetails.active
              ? Positioned(
                  top: 0.25,
                  right: 0.25,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                )
              : Container(height: 0, width: 0),
        ],
      ),
    );
  }
}
