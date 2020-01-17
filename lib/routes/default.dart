import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/services/alerts.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';
import 'package:hcbe_alerts/widgets/loading.dart';

class DefaultPage extends StatefulWidget {
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  StateModel appState;
  bool _loadingVisible = false;
  String _currentCode = "";
  String _currentCodeImg = "assets/code_green.png";
  String _currentSchoolName = "";

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    final schoolId = appState?.user?.school ?? '';

    if (appState.isLoading) {
      _loadingVisible = true;
    } else {
      _loadingVisible = false;
    }

    final activeIntruder = RaisedButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey,
      child: Text("Active Intruder"),
    );
    final codeRed = RaisedButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.red,
      child: Text("Code Red"),
    );
    final codeYellow = RaisedButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.yellow,
      child: Text("Code Yellow"),
    );
    final codeBlue = RaisedButton(
      onPressed: () {
        Alerts.fire("blue");
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.blue,
      child: Text("Code Blue"),
    );

    build() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                _currentSchoolName,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 24,
                    ),
              ),
            ),
            SizedBox(height: 12.0),
            Hero(
              tag: 'hero',
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 90.0,
                  child: ClipOval(
                    child: Image.asset(
                      _currentCodeImg,
                      fit: BoxFit.cover,
                      width: 160.0,
                      height: 160.0,
                    ),
                  )),
            ),
            Center(
                child: Text("Currently active: " + _currentCode,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 10.0),
            activeIntruder,
            SizedBox(height: 10.0),
            codeRed,
            SizedBox(height: 10.0),
            codeYellow,
            SizedBox(height: 10.0),
            codeBlue,
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        // title: Text('HCBE Alerts'),
        actions: <Widget>[
          IconButton(
            icon: Platform.isIOS
                ? Icon(
                    CupertinoIcons.settings,
                  )
                : Icon(
                    Icons.settings,
                  ), // icon is 48px widget.
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('schools')
                    .document(schoolId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  }
                  var doc = snapshot.data;

                  switch (doc["schoolAlertState"]) {
                    case "red":
                      _currentCodeImg = 'assets/code_red.png';
                      break;
                    default:
                  }

                  switch (doc["schoolAlertState"]) {
                    case "red":
                      _currentCode = "Code Red";
                      break;
                    case "blue":
                      _currentCode = "Code Blue";
                      break;
                    case "intruder":
                      _currentCode = "Active Intruder";
                      break;
                    case "yellow":
                      _currentCode = "Code Yellow";
                      break;
                    default:
                      _currentCode = "Code Green";
                  }
                  _currentSchoolName = doc["name"];

                  return build();
                },
              )),
          inAsyncCall: _loadingVisible),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
