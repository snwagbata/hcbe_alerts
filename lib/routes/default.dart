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
import 'package:line_awesome_icons/line_awesome_icons.dart';

class DefaultPage extends StatefulWidget {
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  StateModel appState;
  bool _loadingVisible = false;
  String _currentCode = "";
  Icon _currentCodeImg;
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

    final activeIntruder = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 5,
      onPressed: () {
        _confirmAlertTrigger(context, "Active Intruder", "intruder");
      },
      padding: EdgeInsets.symmetric(vertical: 6),
      color: (Theme.of(context).brightness == Brightness.dark)
          ? Colors.purple
          : Color(0XFFd05ce3),
      child: Text("Active Intruder"),
    );
    final codeRed = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 5,
      onPressed: () {
        _confirmAlertTrigger(context, "Code Red", "red");
      },
      padding: EdgeInsets.symmetric(vertical: 6),
      color: Colors.red,
      child: Text("Code Red"),
    );
    final codeYellow = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 5,
      onPressed: () {
        _confirmAlertTrigger(context, "Code Yellow", "yellow");
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Color(0xFFffc107),
      child: Text("Code Yellow"),
    );
    final codeBlue = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 5,
      onPressed: () {
        _confirmAlertTrigger(context, "Code Blue", "blue");
      },
      padding: EdgeInsets.symmetric(vertical: 4),
      color: Colors.blue,
      child: Text("Code Blue"),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15),
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

              switch (doc["schoolAlertState"]) {
                case "intruder":
                  _currentCodeImg = Icon(LineAwesomeIcons.exclamation_triangle,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? Colors.purple
                          : Color(0XFFd05ce3),
                      size: 120);
                  break;
                case "red":
                  _currentCodeImg = Icon(LineAwesomeIcons.times_circle_o,
                      color: Colors.red, size: 120);
                  break;
                case "yellow":
                  _currentCodeImg = Icon(LineAwesomeIcons.minus_circle,
                      color: Color(0xFFffc107), size: 120);
                  break;
                case "blue":
                  _currentCodeImg = Icon(LineAwesomeIcons.plus_circle,
                      color: Colors.blue, size: 120);
                  break;
                default:
                  _currentCodeImg = Icon(
                    LineAwesomeIcons.check_circle,
                    color: Colors.green,
                    size: 120,
                  );
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
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: <Widget>[
                  Center(
                    child: AutoSizeText(
                      _currentSchoolName,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 22,
                          ),
                      minFontSize: 16,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: _currentCodeImg,
                          ),
                          Center(
                            child: Text(
                              "Currently active: " + _currentCode,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (!doc["schoolAlertActive"])
                      ? GridView.count(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 3,
                          padding:
                              EdgeInsets.symmetric(vertical: 30, horizontal: 7),
                          children: <Widget>[
                            activeIntruder,
                            codeRed,
                            codeYellow,
                            codeBlue,
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(width: 30),
                            Card(
                              child: TextField(
                                enableSuggestions: true,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: '',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      // send alert message update to firebase and display flushbar with "message sent" message
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Column(
                                children: [
                                  Text(
                                    _currentCode + " Quick Reference",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  _codeProcedures,
                                ],
                              ),
                            )
                          ],
                        ),
                ],
              );
            },
          ),
          inAsyncCall: _loadingVisible),
    );
  }
}
