import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';

class SchoolAdminPage extends StatefulWidget {
  @override
  _SchoolAdminPageState createState() => _SchoolAdminPageState();
}

class _SchoolAdminPageState extends State<SchoolAdminPage> {
  StateModel appState;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("school admin"),),
      drawer: NavDrawer(),
      body: Container(),
    );
  
  }
}