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
  String _currentCodeImg = "";
  String _currentSchoolName = "";

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (appState.isLoading) {
      _loadingVisible = true;
    } else {
      _loadingVisible = false;
    }

    final schoolId = appState?.user?.school ?? '';

    setState(() async {
      _currentCode = await Alerts.getCurrentAlertName(schoolId);
      _currentCodeImg = await Alerts.getAlertImgPath(schoolId);
      var doc = await Firestore.instance.document("schools/$schoolId").get();
      _currentSchoolName = doc.data["schoolAlertState"];
    });

    final codeImage = Hero(
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
    );

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

    final schoolName = Text(
      _currentSchoolName,
      style: Theme.of(context).textTheme.title.copyWith(
            fontSize: 24,
          ),
    );

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(child: schoolName),
                  SizedBox(height: 12.0),
                  codeImage,
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
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
