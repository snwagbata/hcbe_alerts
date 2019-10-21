import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcbe_alerts/models/user.dart';
import 'package:hcbe_alerts/routes/login.dart';
//
import 'package:hcbe_alerts/services/firebase.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/services/validator.dart';
import 'package:hcbe_alerts/widgets/loading.dart';
import 'package:hcbe_alerts/widgets/navigator.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _school;
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //Responsive scaling widget init
    ScreenUtil.instance = ScreenUtil(width: 360.0, height: 596.5)
      ..init(context);

    /// HCBE Logo
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

    ///School Input dropdown
    final school = StreamBuilder(
      stream: Firestore.instance.collection('schools').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          Center(
            child: const CupertinoActivityIndicator(),
          );
        return FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.school),
                ),
                labelText: 'School',
              ),
              child: Container(
                child: Row(
                  children: <Widget>[
                    DropdownButton<String>(
                      hint: Text("Please select your school",
                          style: TextStyle(fontSize: 15.0)),
                      value: _school,
                      isExpanded: false,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() {
                          _school = newValue;
                        });
                      },
                      items: snapshot.data != null
                          ? snapshot.data.documents
                              .map((DocumentSnapshot document) {
                              return new DropdownMenuItem<String>(
                                  value: document.documentID,
                                  child: new Container(
                                    height: 100.0,
                                    //color: primaryColor,
                                    child: new Text(
                                      document.data['name'].toString(),
                                    ),
                                  ));
                            }).toList()
                          : DropdownMenuItem(
                              value: 'null',
                              child: new Container(
                                height: 100.0,
                                child: new Text('null'),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    final name = TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      controller: _name,
      validator: Validator.validateName,
      focusNode: _nameFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _nameFocus, _emailFocus);
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        labelText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
                ), // icon is 48px widget.
        ), // icon is 48px widget.
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      textInputAction: TextInputAction.done,
      focusNode: _passFocus,
      onFieldSubmitted: (value) {
        _passFocus.unfocus();
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(
                  CupertinoIcons.padlock,
                )
              : Icon(
                  Icons.lock,
                ), // icon is 48px widget.
        ), // icon is 48px widget.
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: () {
          _emailSignUp(
              name: _name.text,
              email: _email.text,
              password: _password.text,
              school: _school,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        'Have an Account? Sign In.',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        popPushPage(context, LoginPage());
      },
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
                      school,
                      SizedBox(height: 12.0),
                      name,
                      SizedBox(height: 12.0),
                      email,
                      SizedBox(height: 12.0),
                      password,
                      SizedBox(height: 6.0),
                      signUpButton,
                      signInLabel
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

  void _emailSignUp(
      {String name,
      String email,
      String password,
      String school,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await Auth.signUp(email, password).then((uID) {
          Auth.addUserSettingsDB(new User(
            userId: uID,
            email: email,
            name: name,
            school: school,
            isSchoolAdmin: false,
            isDistrictAdmin: false,
          ));
        });
        Flushbar(
          message: 'Account created',
          duration: Duration(seconds: 3),
          flushbarStyle: FlushbarStyle.FLOATING,
          margin: EdgeInsets.all(8),
          borderRadius: 5,
        )..show(context);
        //now automatically login user too and go to homepage
        await StateWidget.of(context).logInUser(email, password, context);
        Navigator.pop(context);
      } catch (e) {
        _changeLoadingVisible();
        print("Sign Up Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
          title: "Sign Up Error",
          message: exception,
          duration: Duration(seconds: 3),
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
