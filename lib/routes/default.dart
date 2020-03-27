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
    final userId = appState?.user?.getUserId();

    if (appState.isLoading) {
      _loadingVisible = true;
    } else {
      _loadingVisible = false;
    }

    ///TODO might implement a full screen confirmation dialog to handle alert triggers
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

    final activeIntruderProcedures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Quickly clear the hall of any students near your room.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near an exterior door, ensure that door is closed and locked, if possible and safe.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near a restroom, quickly clear that restroom only, if possible and safe.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Lock your classroom door and "),
                TextSpan(
                    text: "DO NOT",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    )),
                TextSpan(
                    text:
                        " open the door for anyone. Admin and staff will opwn with a key if entry is needed.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Slide the appropriate colored card under the door. (Green = All Good, Yellow = Missing Students, Red = Emergency in the Room)",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Cover your classroom door and close the blinds on the outside window.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Turn off the lights.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Place students on the floor out of sight of the window.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Ensure your cell phone is turned on.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "DO NOT",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                    text:
                        " allow any student calls. Have students turn their phones off so no sounds are made.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "DO NOT",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: " let students leave the room for ",
                ),
                TextSpan(
                  text: "ANY",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: " reason.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "PRIORITIZE your and your students' safety 1st!",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Barricade your door from the inside using any and all available funiture near the classroom door.",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
    final codeRedProcedures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Quickly clear the hall of any students near your room.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near an exterior door, ensure that door is closed and locked, if possible and safe.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near a restroom, quickly clear that restroom only, if possible and safe.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Lock your classroom door and "),
                TextSpan(
                    text: "DO NOT",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    )),
                TextSpan(
                    text:
                        " open the door for anyone. Admin and staff will opwn with a key if entry is needed.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Slide the appropriate colored card under the door. (Green = All Good, Yellow = Missing Students, Red = Emergency in the Room)",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Cover your classroom door and close the blinds on the outside window.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Turn off the lights.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Place students on the floor out of sight of the window.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Ensure your cell phone is turned on.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "DO NOT",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                    text:
                        " allow any student calls. Have students turn their phones off so no sounds are made.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "DO NOT",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: " let students leave the room for ",
                ),
                TextSpan(
                  text: "ANY",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: " reason.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
      ],
    );
    final codeYellowProcedures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Quickly clear the hall of any students near your room.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near an exterior door, ensure that door is closed and locked.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "If near a restroom, quickly clear that restroom only.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Lock your classroom door.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Slide the appropriate colored card under the door. (Green = All Good, Yellow = Missing Students, Red = Emergency in the Room)",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Ensure your cell phone is turned on.",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "DO NOT",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: " let students leave the room for ",
                ),
                TextSpan(
                  text: "ANY",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: " reason.")
              ],
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Continue with normal classroom operations.",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
    final codeBlueProcedures = Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Remove students from the immediate area and send to a neighboring classroom. Remain with the student in need of help until assistance arrives.",
          style: TextStyle(fontSize: 15),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "ALL teachers/classrooms, continue with classs as normal and limit students leaving the room to emergencies only.",
          style: TextStyle(fontSize: 15),
        ),
      ),
    ]);
    final codeGreenProcedures = Container();

    /// default build for when the schoolAlertActive is false
    initBuild() {
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
          Align(
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
    }

    /// if schoolAlertActive is true this build is returned
    alertActiveBuild(AsyncSnapshot snapshot) {
      var doc = snapshot.data;
      Widget _codeProcedures;

      switch (doc["schoolAlertState"]) {
        case "red":
          _codeProcedures = codeRedProcedures;
          break;
        case "blue":
          _codeProcedures = codeBlueProcedures;
          break;
        case "intruder":
          _codeProcedures = activeIntruderProcedures;
          break;
        case "yellow":
          _codeProcedures = codeYellowProcedures;
          break;
        default:
          _codeProcedures = codeGreenProcedures;
      }
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
          SizedBox(height: 16.0),
          Align(
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
                  )),
            ),
          ),
          Center(
            child: Text("Currently active: " + _currentCode,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 15.0),
          Column(
            children: <Widget>[
              Text(
                _currentCode + " Quick Reference",
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              _codeProcedures,
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        title: Text('HCBE Alerts'),
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
      body: LoadingScreen(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('schools')
                .document(schoolId)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Loading",
                  ),
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
              if (doc["schoolAlertActive"]) {
                return alertActiveBuild(snapshot);
              } else {
                return initBuild();
              }
            },
          ),
          inAsyncCall: _loadingVisible),
    );
  }
}
