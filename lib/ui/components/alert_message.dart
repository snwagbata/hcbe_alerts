import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/models.dart' show DistressMessage;

class AlertMessage extends StatelessWidget {
  final DistressMessage message;
  AlertMessage({this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(message.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return Text(
                    "${snapshot.data.data['name']} (1101)"); //number right next to name is user room number
              }
              return Text("Anonymous user");
            },
          ),
          subtitle: Text(message.message),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 0,
          ),
        ),
        Divider(),
      ],
    );
  }
}
