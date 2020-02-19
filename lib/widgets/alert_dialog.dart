import 'package:flutter/material.dart';
import 'package:hcbe_alerts/services/alerts.dart';

class DistressDialog extends StatelessWidget {
  final String title;
  final String alert;
  final String schoolId;
  final Color color;
  final TextEditingController _alertMessage = TextEditingController();

  DistressDialog({
    @required this.title,
    @required this.alert,
    @required this.schoolId,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 5,
          right: 5,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              "Are you sure you want to initiate a " +
                  title.toUpperCase() +
                  " alert?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _alertMessage,
              decoration: InputDecoration(
                hintText: "(OPTIONAL)Please provide further details",
                hintStyle: TextStyle(
                  fontSize: 10.0,
                ),
                hintMaxLines: 3,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                        onPressed: () {Alerts.fire(schoolId, alert);},
                        child: Text(
                            "Initiate")) //TODO Get message from alert message and pass to Alerts.fire()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
