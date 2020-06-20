import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/ui/components/components.dart';
import 'package:hcbe_alerts/helpers/helpers.dart';
import 'package:hcbe_alerts/services/services.dart';

class ResetPasswordUI extends StatefulWidget {
  _ResetPasswordUIState createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final email = TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      validator: Validator.email,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(CupertinoIcons.mail,
                  color: Theme.of(context).iconTheme.color)
              : Icon(Icons.email, color: Theme.of(context).iconTheme.color),
        ),
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('RESET PASSWORD'),
        elevation: 5.0,
      ),
      body: LoadingScreen(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LogoGraphicHeader(),
                    SizedBox(height: 24.0),
                    email,
                    SizedBox(height: 6.0),
                    PrimaryButton(
                      labelText: 'Send password reset email',
                      onPressed: () => _reset(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  _reset() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = !_loading;
      });
      AuthService _auth = AuthService();
      await _auth.sendPasswordResetEmail(_email.text);

      setState(() {
        _loading = !_loading;
      });

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            'Check your email and follow the instructions to reset your password.'),
      ));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
