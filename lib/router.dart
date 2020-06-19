import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/user_model.dart';
import 'package:hcbe_alerts/ui/ui.dart';
import 'package:provider/provider.dart';

class UserRouter extends StatefulWidget {
  @override
  _UserRouterState createState() => _UserRouterState();
}

class _UserRouterState extends State<UserRouter> {
  String _userType;

   @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _userType = user.userType;
      });
    }

    if(_userType == 'schoolAdmin'){
      return SchoolAdminUI();
    }

    if(_userType == 'districtAdmin'){
      return DistrictAdminUI();
    }
    
    return HomeUI();
  }
}