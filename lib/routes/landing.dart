import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcbe_alerts/widgets/navigator.dart';
import 'package:hcbe_alerts/routes/login.dart';
import 'package:hcbe_alerts/routes/register.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    //Responsive scaling widget init
    ScreenUtil.instance = ScreenUtil(width: 360.0, height: 596.5)
      ..init(context);

    /// HCBE Alert App Logo for Landing Page
    final logo = Container(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setSp(25.0)),
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          height: ScreenUtil.getInstance().setHeight(200),
        ),
      ),
    );

    final registerPage = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(30),
        right: ScreenUtil.getInstance().setWidth(30),
        top: ScreenUtil.getInstance().setHeight(20),
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.white,
              borderSide: BorderSide(
                color: Colors.white, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: ScreenUtil.getInstance()
                    .setWidth(0.8), //width of the border
              ),
              highlightedBorderColor: Colors.white,
              onPressed: () => pushPage(context, RegisterPage()),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil.getInstance().setHeight(20.0),
                  horizontal: ScreenUtil.getInstance().setWidth(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "SIGN UP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final loginPage = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(30),
        right: ScreenUtil.getInstance().setWidth(30),
        top: ScreenUtil.getInstance().setHeight(30),
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.white,
            onPressed: () => pushPage(context, LoginPage()),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil.getInstance().setHeight(20.0),
                horizontal: ScreenUtil.getInstance().setWidth(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.contain,
            repeat: ImageRepeat.repeatX,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              SizedBox(height: ScreenUtil.getInstance().setHeight(12)),
              registerPage,
              loginPage
            ],
          ),
        ),
      ),
    );
  }
}
