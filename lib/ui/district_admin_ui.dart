import 'package:flutter/material.dart';
import 'package:hcbe_alerts/services/services.dart';

class DistrictAdminUI extends StatefulWidget {
  @override
  _DistrictAdminUIState createState() => _DistrictAdminUIState();
}

class _DistrictAdminUIState extends State<DistrictAdminUI> {

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
    return Container(
      
    );
  }
}