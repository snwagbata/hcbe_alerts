import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/services/alerts.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/distress_dialog.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';
import 'package:hcbe_alerts/widgets/loading.dart';
import 'package:location_permissions/location_permissions.dart';

class DefaultPage extends StatefulWidget {
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  StateModel appState;
  PermissionStatus _status;
  bool _loadingVisible = false;
  String _currentCode = "";
  String _currentCodeImg = "assets/code_green.png";
  String _currentSchoolName = "";

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    final schoolId = appState?.user?.school ?? '';
    final userId = appState?.user?.getUserId();

    if (appState.isLoading) {
      _loadingVisible = true;
    } else {
      _loadingVisible = false;
    }

    Future<void> _confirmAlertTrigger(
        BuildContext context, String title, String alert) async {
      final bool didTriggerAlert = await DistressAlertDialog(
        title: title,
        cancelActionText: 'Cancel',
        defaultActionText: 'Initiate alert',
        schoolId: schoolId,
        alert: alert,
      ).show(context);
      if (didTriggerAlert != false) {
        await Alerts.fire(schoolId, alert, userId);
      }
    }

    final activeIntruder = RaisedButton(
      onPressed: () {
        _confirmAlertTrigger(context, "Active Intruder", "intruder");
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey,
      child: Text("Active Intruder"),
    );
    final codeRed = RaisedButton(
      onPressed: () {
        _confirmAlertTrigger(context, "Code Red", "red");
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.red,
      child: Text("Code Red"),
    );
    final codeYellow = RaisedButton(
      onPressed: () {
        _confirmAlertTrigger(context, "Code Yellow", "yellow");
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.yellow,
      child: Text("Code Yellow"),
    );
    final codeBlue = RaisedButton(
      onPressed: () {
        _confirmAlertTrigger(context, "Code Blue", "blue");
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
              child: AutoSizeText(
                _currentSchoolName,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 22,
                    ),
                minFontSize: 16,
                maxLines: 2,
                textAlign: TextAlign.center,
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
                      _currentCodeImg = 'assets/code_green.png';
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
    LocationPermissions().checkPermissionStatus().then(_updateStatus);
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _askPermission() async {
    await LocationPermissions().requestPermissions().then(_onStatusRequested);
  }

  void _onStatusRequested(PermissionStatus value) {
    if (value != PermissionStatus.granted) {
      LocationPermissions().openAppSettings();
    } else {
      _updateStatus(value);
    }
  }
}
