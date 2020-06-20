import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/ui/components/components.dart';
import 'package:hcbe_alerts/helpers/helpers.dart';
import 'package:hcbe_alerts/services/services.dart';

class SignUpUI extends StatefulWidget {
  _SignUpUIState createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _school = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _schoolFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  bool _autoValidate = false;
  bool _passwordVisible;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _passwordVisible = true;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _school.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _nameFocus.dispose();
    _schoolFocus.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final school = TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _school,
      focusNode: _schoolFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _schoolFocus, _nameFocus);
      },
      validator: Validator.school,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(Icons.code, color: Theme.of(context).iconTheme.color),
        ),
        labelText: 'School code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      ),
    );

    final name = TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      controller: _name,
      validator: Validator.name,
      focusNode: _nameFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _nameFocus, _emailFocus);
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        labelText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      ),
    );

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
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: _passwordVisible,
      controller: _password,
      validator: Validator.password,
      textInputAction: TextInputAction.done,
      focusNode: _passFocus,
      onFieldSubmitted: (value) {
        _passFocus
            .unfocus(); //TODO use this in [DefaultUI] to handle textformfield focus
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(
                  CupertinoIcons.padlock,
                  color: Theme.of(context).iconTheme.color,
                )
              : Icon(
                  Icons.lock,
                  color: Theme.of(context).iconTheme.color,
                ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        title: Text('SIGN UP'),
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
                    school,
                    SizedBox(height: 12.0),
                    name,
                    SizedBox(height: 12.0),
                    email,
                    SizedBox(height: 12.0),
                    password,
                    SizedBox(height: 6.0),
                    PrimaryButton(
                      labelText: 'Sign Up',
                      onPressed: () => _signUp(
                        name: _name.text,
                        email: _email.text,
                        password: _password.text,
                        school: _school.text,
                        context: context,
                      ),
                    ),
                    LabelButton(
                      labelText: 'Have an account? Sign in.',
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/reset-password'),
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

  _signUp({
    String name,
    String email,
    String password,
    String school,
    BuildContext context,
  }) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        setState(() {
          _loading = true;
        });
        AuthService _auth = AuthService();
        await _auth.checkSchoolExist(school);
        await _auth.registerWithEmailAndPassword(
          _name.text,
          _email.text,
          _password.text,
        );

        await PushNotificationService().subscribeToNotification(school);

        setState(() {
          _loading = false;
        });

        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Account created. User verification email sent.')));
      } catch (e) {
        setState(() {
          _loading = false;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getExceptionText(e)),
          ),
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
