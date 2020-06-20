import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/ui/components/components.dart';
import 'package:hcbe_alerts/helpers/helpers.dart';
import 'package:hcbe_alerts/services/services.dart';

class SignInUI extends StatefulWidget {
  _SignInUIState createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  bool _autoValidate = false;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final email = TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _emailFocus, _passFocus);
      },
      //validator: Validator.email, TODO uncomment this when checking todos
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(CupertinoIcons.mail,
                  color: Theme.of(context).iconTheme.color)
              : Icon(Icons.email, color: Theme.of(context).iconTheme.color),
        ),
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passFocus,
      onFieldSubmitted: (value) {
        _passFocus.unfocus();
      },
      controller: _password,
      validator: Validator.password,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(CupertinoIcons.padlock,
                  color: Theme.of(context).iconTheme.color)
              : Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
        ),
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('SIGN IN'),
        centerTitle: true,
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
                    SizedBox(height: 12.0),
                    password,
                    SizedBox(height: 6.0),
                    PrimaryButton(
                      labelText: 'Sign In',
                      onPressed: () => _login(
                          email: _email.text,
                          password: _password.text,
                          context: context),
                    ),
                    LabelButton(
                      labelText: 'Forgot password?',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/reset-password'),
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

  void _login({
    String email,
    String password,
    BuildContext context,
  }) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        setState(() {
          _loading = true;
        });
        AuthService _auth = AuthService();
        
        _auth.signInWithEmailAndPassword(email, password).then(
            (user) => _auth.getUserFirestore(user.uid).then(
                (value) => PushNotificationService()
                    .subscribeToNotification(value.school)));
      } catch (e) {
        setState(() {
          _loading = false;
        });
        print("Sign In Error: $e");
        String exception = ErrorHandler.getExceptionText(e);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(exception),
          ),
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
