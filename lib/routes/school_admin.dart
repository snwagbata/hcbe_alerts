import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/services/alerts.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/alert_card.dart';
import 'package:hcbe_alerts/widgets/distress_dialog_admin.dart';
import 'package:hcbe_alerts/widgets/loading.dart';

class SchoolAdminPage extends StatefulWidget {
  @override
  _SchoolAdminPageState createState() => _SchoolAdminPageState();
}

class _SchoolAdminPageState extends State<SchoolAdminPage> {
  StateModel appState;
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

    Future<void> _confirmCodeGreen(BuildContext context, String alertId) async {
      final bool codeGreen = await DistressAlertAdminDialog(
        title: "Code Green",
        cancelActionText: 'Cancel',
        defaultActionText: 'Initiate alert',
        schoolId: schoolId,
        alert: "green",
      ).show(context);
      if (codeGreen != false) {
        await Alerts.goGreen(schoolId, alertId);
      }
    }

    Future<void> _confirmAlertTrigger(
        BuildContext context, String title, String alert) async {
      final bool didTriggerAlert = await DistressAlertAdminDialog(
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

    final activeIntruder = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _confirmAlertTrigger(context, "Active Intruder", "intruder");
        },
        padding: EdgeInsets.symmetric(vertical: 12),
        color: Colors.grey,
        child: Text("Active Intruder"),
      ),
    );
    final codeRed = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _confirmAlertTrigger(context, "Code Red", "red");
        },
        padding: EdgeInsets.symmetric(vertical: 12),
        color: Colors.red,
        child: Text("Code Red"),
      ),
    );
    final codeYellow = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _confirmAlertTrigger(context, "Code Yellow", "yellow");
        },
        padding: EdgeInsets.symmetric(vertical: 12),
        color: Colors.yellow,
        child: Text("Code Yellow"),
      ),
    );
    final codeBlue = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _confirmAlertTrigger(context, "Code Blue", "blue");
        },
        padding: EdgeInsets.symmetric(vertical: 12),
        color: Colors.blue,
        child: Text("Code Blue"),
      ),
    );
    _codeGreen(String alertId) {
      return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            _confirmCodeGreen(context, alertId);
          },
          padding: EdgeInsets.symmetric(vertical: 12),
          color: Colors.green,
          child: Text("Code Green"),
        ),
      );
    }

    /// Default home screen
    _home() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('schools')
            .document(schoolId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Loading",
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Center(
              child: Text(
                  "We could not find a school associated with you. Please change your school."),
            );
          }
          var doc = snapshot.data;

          ///TODO add the images for the other codes
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
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            children: <Widget>[
              Center(
                child: AutoSizeText(
                  _currentSchoolName,
                  style: Theme.of(context).textTheme.headline.copyWith(
                        fontSize: 22,
                      ),
                  minFontSize: 16,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: 'code image',
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
                    ),
                  ),
                ),
              ),
              Center(
                  child: Text("Currently active: " + _currentCode,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              doc["schoolAlertActive"]
                  ? Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          _codeGreen(doc["curAlertId"]),
                          SizedBox(height: 10.0),
                          //codeRed,
                          SizedBox(height: 10.0),
                          //codeYellow,
                          SizedBox(height: 10.0),
                          //codeBlue,
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
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
            ],
          );
        },
      );
    }

    _buildAlertsList(BuildContext context, List<DocumentSnapshot> snapshots) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshots.length,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return AlertCard(
            alertDetails: Distress.fromDocument(snapshots[index]),
          );
        },
      );
    }

    /// build Alerts list for the users school
    _buildSchoolAlertList() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('alerts')
            .where('schoolId', isEqualTo: schoolId)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          while (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: "loading",
              ),
            );
          }

          if (snapshot.data == null) {
            return Center(
              child: Text(
                "No alerts have been activated yet.",
                style: Theme.of(context).textTheme.body1,
              ),
            );
          }

          return _buildAlertsList(context, snapshot.data.documents);
        },
      );
    }

    ///On this page, implement a two tabbed page
    ///one page is normal button view but will show only the green button when schoolAlertState is true
    ///The other page will be a page with a list of past and current alerts in a card like the flight card in the flight app
    ///with lazy loading 10 cards loaded each time
    ///tap on each card will send to another page to view details of the alert
    ///pass alert id to page builder ex AlertPage(firebase_id), and AlertPage will build based on data it gets from firebase
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text("HCBE Alerts"),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
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
                bottom: new TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.home,
                        semanticLabel: "Home",
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.notification_important,
                        semanticLabel: "Alerts List",
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: LoadingScreen(
              child: TabBarView(
                children: [
                  _home(),
                  _buildSchoolAlertList(),
                ],
              ),
              inAsyncCall: _loadingVisible),
        ),
      ),
    );
  }
}
