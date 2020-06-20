import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/models.dart';
import 'package:hcbe_alerts/services/services.dart';
import 'package:hcbe_alerts/ui/components/components.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SchoolAdminUI extends StatefulWidget {
  @override
  _SchoolAdminUIState createState() => _SchoolAdminUIState();
}

class _SchoolAdminUIState extends State<SchoolAdminUI> {
  String school;
  String _currentCode = "";
  Icon _currentCodeImg;
  String _currentSchoolName = "";

  @override
  void initState() {
    super.initState();
    LocationInit.initLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    setState(() {
      school = user?.school;
    });

    Future<void> _confirmCodeGreen(BuildContext context, String alertId) async {
      final bool codeGreen = await DistressAlertAdminDialog(
        title: "Code Green",
        cancelActionText: 'Cancel',
        defaultActionText: 'Go Green',
        alert: "green",
      ).show(context);
      if (codeGreen != false) {
        Alerts.goGreen(school, alertId);
      }
    }

    Future<void> _confirmAlertTrigger(
        BuildContext context, String title, String alert) async {
      final bool didTriggerAlert = await DistressAlertAdminDialog(
        title: title,
        cancelActionText: 'Cancel',
        defaultActionText: 'Initiate alert',
        alert: alert,
      ).show(context);
      if (didTriggerAlert != false) {
        await Alerts.fire(school, alert, user.uid);
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

    _codeGreen(String alertId) {
      return CodeButton(
        labelText: "Code Green",
        color: Colors.green,
        onPressed: () => _confirmCodeGreen(context, alertId),
      );
    }

    /// Default home screen
    _home() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('schools')
            .document(school)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          while (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Loading",
              ),
            );
          }

          if (snapshot.hasData) {
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
            return Builder(
              // This Builder is needed to provide a BuildContext that is "inside"
              // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
              // find the NestedScrollView.
              builder: (BuildContext context) {
                return CustomScrollView(
                  key: PageStorageKey("home"),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                SizedBox(height: 4.0),
                                Center(
                                  child: AutoSizeText(
                                    _currentSchoolName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                          fontSize: 22,
                                        ),
                                    minFontSize: 16,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 7),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                doc["schoolAlertActive"]
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 10.0),
                                            _codeGreen(doc["curAlertId"]),
                                          ],
                                        ),
                                      )
                                    : GridView.count(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2,
                                        childAspectRatio: 4 / 3,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 7),
                                        children: <Widget>[
                                          activeIntruder,
                                          codeRed,
                                          codeYellow,
                                          codeBlue,
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Center(
            child: Text(
                "We could not find a school associated with you. Please change your school.",),
          );
        },
      );
    }

    /// build Alerts list for the users school
    _buildSchoolAlertList() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('alerts')
            .where('schoolId', isEqualTo: school)
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

          if (snapshot.hasData) {
            return Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
                  key: PageStorageKey("alertList"),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AlertCard(
                            alertDetails: Distress.fromDocument(
                              snapshot.data.documents[index],
                            ),
                          );
                        },
                        childCount: snapshot.data.documents.length,
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return Center(
            child: Text(
              "No alerts have been activated yet.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        },
      );
    }

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text("HCBE Alerts"),
                  floating: true,
                  pinned: true,
                  snap: false,
                  primary: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    IconButton(
                      icon: Platform.isIOS
                          ? Icon(CupertinoIcons.settings)
                          : Icon(Icons.settings),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                    ),
                  ],
                  bottom: TabBar(
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
              ),
            ];
          },
          body: TabBarView(
            children: [
              _home(),
              _buildSchoolAlertList(),
            ],
          ),
        ),
      ),
    );
  }
}
