import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/routes/landing.dart';

class UserValidator{
checkForRole(BuildContext context ) async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(user.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return LandingPage();
            } else if (snapshot.hasData) {
              return parseRole(snapshot.data, context);
            }
            return LinearProgressIndicator();
          },
        );
      } else {
        Navigator.of(context).pushReplacementNamed("/landing");
      }
    });
  }

  parseRole(DocumentSnapshot snapshot, BuildContext context) {
    if (snapshot.data['userType'] == 'schoolAdmin') {
      Navigator.of(context).pushReplacementNamed("/schoolAdmin");
    } else if (snapshot.data['userType'] == 'districtAdmin') {
      Navigator.of(context).pushReplacementNamed("/districtAdmin");
    }
    Navigator.of(context).pushReplacementNamed("/default");
  }
}