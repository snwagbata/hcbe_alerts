import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/services/validator.dart';
import 'package:hcbe_alerts/widgets/loading.dart';
import 'package:hcbe_alerts/services/firebase.dart';

class ForgotPasswordPage extends StatefulWidget {
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 36.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(
                  CupertinoIcons.mail,
                )
              : Icon(
                  Icons.email,
                ),
        ),
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final forgotPasswordButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: () {
          _forgotPassword(email: _email.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SEND PASSWORD RESET EMAIL', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 24.0),
                      email,
                      SizedBox(height: 6.0),
                      forgotPasswordButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _forgotPassword({String email, BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState.validate()) {
      try {
        await _changeLoadingVisible();
        await Auth.forgotPasswordEmail(email);
        await _changeLoadingVisible();
        Flushbar(
          title: "Password Reset Email Sent",
          message:
              'Check your email and follow the instructions to reset your password.',
          duration: Duration(seconds: 20),
          flushbarStyle: FlushbarStyle.FLOATING,
          margin: EdgeInsets.all(8),
          borderRadius: 5,
        )..show(context);
      } catch (e) {
        _changeLoadingVisible();
        print("Forgot Password Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
          title: "Forgot Password Error",
          message: exception,
          duration: Duration(seconds: 10),
          flushbarStyle: FlushbarStyle.FLOATING,
          margin: EdgeInsets.all(8),
          borderRadius: 5,
        )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
