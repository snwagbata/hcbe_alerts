import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/services/firebase.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/services/validator.dart';
import 'package:hcbe_alerts/widgets/loading.dart';
/*
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  String _email;
  String _password;
  String _errorMessage;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });
    if (_validateAndSave()) {
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        final FirebaseUser user = result.user;

        _firestore.collection("users").document(user.uid).get();
      } catch (e) {
        print('Error: $e');
        setState(() {
          switch (e.code) {
            case "ERROR_USER_NOT_FOUND":
              _errorMessage = "User not found.";
              return bar(_errorMessage, 5, context);
              break;

            case "ERROR_INVALID_EMAIL":
              _errorMessage = "Email is invalid.";
              return bar(_errorMessage, 5, context);
              break;

            case "ERROR_WRONG_PASSWORD":
              _errorMessage = "Wrong Password";
              return bar(_errorMessage, 5, context);
              break;

            case "ERROR_TOO_MANY_REQUESTS":
              _errorMessage =
                  "There have been too many requests to sign in this user. Please try again later.";
              return bar(_errorMessage, 5, context);
              break;

            case "ERROR_USER_DISABLED":
              _errorMessage =
                  "User is currently disabled. Please contact your systems adminstrator.";
              return bar(_errorMessage, 5, context);
              break;

            default:
              _errorMessage = "Error. Try again later";
              return bar(_errorMessage, 5, context);

              break;
          }
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    super.initState();
  }

  Widget _showLogo() {
    return Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return TextFormField(
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Please enter email' : null,
      onSaved: (value) => _email = value.trim(),
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _emailFocus, _passFocus);
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email*',
        icon: Platform.isIOS
            ? Icon(
                CupertinoIcons.mail,
                color: Colors.grey,
              )
            : Icon(
                Icons.mail,
                color: Colors.grey,
              ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Please enter password.' : null,
        onSaved: (value) => _password = value.trim(),
        autofocus: false,
        obscureText: true,
        textInputAction: TextInputAction.done,
        focusNode: _passFocus,
        onFieldSubmitted: (value) {
          _passFocus.unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Password*',
          icon: Platform.isIOS
              ? Icon(
                  CupertinoIcons.padlock,
                  color: Colors.grey,
                )
              : Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }

  Widget _showLoginButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: double.infinity, // match_parent
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Text('Login',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            color: Color(0xff00457c), //used color from SSO portal
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeatX,
            )),
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                _showLogo(),
                Card(
                  color: Colors.white,
                  elevation: 6.0,
                  margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 50.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _showEmailInput(),
                          _showPasswordInput(),
                          _showLoginButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

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
                ),
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
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Platform.isIOS
              ? Icon(
                  CupertinoIcons.padlock,
                )
              : Icon(
                  Icons.lock,
                ), //icon is 48px widget.
        ), // icon is 48px widget.
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: () {
          _emailLogin(
              email: _email.text, password: _password.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/forgot-password');
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
                      email,
                      SizedBox(height: 12.0),
                      password,
                      SizedBox(height: 6.0),
                      loginButton,
                      forgotLabel,
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

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await StateWidget.of(context).logInUser(email, password, context);
      } catch (e) {
        _changeLoadingVisible();
        print("Sign In Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
          title: "Sign In Error",
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
