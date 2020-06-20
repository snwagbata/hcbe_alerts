import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/services/services.dart'
    show PushNotificationService, LocationInit, Alerts;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:hcbe_alerts/models/models.dart' show UserModel;
import 'package:hcbe_alerts/ui/components/components.dart'
    show DistressAlertDialog, CodeButton, LoadingScreen;

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _loading = false;
  String _currentCode = "";
  Icon _currentCodeImg;
  String _currentSchoolName = "";
  String school;
  String uid;
  FocusNode _aMessage = FocusNode();
  TextEditingController _alertMessage = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    LocationInit.initLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    setState(() {
      school = user?.school;
      uid = user?.uid;
    });

    Future<void> _confirmAlertTrigger(
        BuildContext context, String title, String alert) async {
      final bool didTriggerAlert = await DistressAlertDialog(
        title: title,
        cancelActionText: 'Cancel',
        defaultActionText: 'Initiate alert',
        alert: alert,
      ).show(context);
      if (didTriggerAlert != false) {
        await Alerts.fire(school, alert, uid);
      }
    }

    final activeIntruder = CodeButton(
      labelText: "Active Intruder",
      color: (Theme.of(context).brightness == Brightness.dark)
          ? Colors.purple
          : Color(0XFFd05ce3),
      onPressed: () =>
          _confirmAlertTrigger(context, "Active Intruder", "intruder"),
    );

    final codeRed = CodeButton(
      labelText: "Code Red",
      color: Colors.red,
      onPressed: () => _confirmAlertTrigger(context, "Code Red", "red"),
    );

    final codeYellow = CodeButton(
      labelText: "Code Yellow",
      color: Color(0xFFffc107),
      onPressed: () => _confirmAlertTrigger(context, "Code Yellow", "yellow"),
    );

    final codeBlue = CodeButton(
      labelText: "Code Blue",
      color: Colors.blue,
      onPressed: () => _confirmAlertTrigger(context, "Code Blue", "blue"),
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
    final codeBlueProcedures = Column(
      children: <Widget>[
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
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 5.0,
        title: Text('HCBE Alerts'),
        actions: <Widget>[
          IconButton(
            icon: Platform.isIOS
                ? Icon(CupertinoIcons.settings)
                : Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: LoadingScreen(
        inAsyncCall: _loading,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('schools')
                .document(school)
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
              }
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: <Widget>[
                  SizedBox(height: 7),
                  Center(
                    child: AutoSizeText(
                      _currentSchoolName,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 22,
                          ),
                      minFontSize: 16,
                      maxLines: 1,
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
                            //The alert messaging system below will be turned
                            //before project goes into production
                            //TODO[Somto]
                            Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: TextField(
                                  controller: _alertMessage,
                                  focusNode: _aMessage,
                                  enableSuggestions: true,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    labelText: '',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        _aMessage.unfocus();
                                        if (_alertMessage.text != "") {
                                          Alerts.updateAlertMessages(
                                            _alertMessage.text,
                                            doc["curAlertId"],
                                            user.uid,
                                          );
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text("Message sent"),
                                            ),
                                          );
                                          _alertMessage.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentCode + " Quick Reference",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    _codeProcedures,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
