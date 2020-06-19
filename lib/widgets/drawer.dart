import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/routes/admin_alert_detail.dart';

class NavDrawer extends StatelessWidget {
  ///Drawer Header with HCBE logo
  final header = DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/bg.jpg"),
        fit: BoxFit.contain,
        repeat: ImageRepeat.repeatX,
      ),
    ),
    child: Center(
      child: Hero(
        tag: 'logo',
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: CircleAvatar(
            radius: 300,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    ),
  );

  _buildSchoolList() {
    return StreamBuilder(
      stream: Firestore.instance.collection('schools').snapshots(),
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
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${snapshot.data.documents[index].data['name']}"),
                onTap: () =>
                    AADetail(snapshot.data.documents[index].data['schoolId']),
              );
            },
          );
        }

        return Center(
          child: Text(
            "Yikes! Seems like no school has been registered yet.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          header,
          ListTile(
            title: Text("Home"),
          ),
          Divider(),
          _buildSchoolList(),
        ],
      ),
    );
  }
}
