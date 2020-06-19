import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:hcbe_alerts/widgets/alert_card.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';

class AADetail extends StatelessWidget {
  final String schoolId;
  AADetail(this.schoolId);


  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: _buildSchoolAlertList(),
      ),
    );
  }
}
