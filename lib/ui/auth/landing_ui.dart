import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingUI extends StatefulWidget {
  @override
  _LandingUIState createState() => _LandingUIState();
}

class _LandingUIState extends State<LandingUI> {
  @override
  Widget build(BuildContext context) {
    //Responsive scaling widget init
    //If you want to set the font size is scaled according to the system's "font size" assist option
    ScreenUtil.init(context, width: 360, height: 596.5, allowFontScaling: true);

    /// HCBE Alert App Logo for Landing Page
    final logo = Container(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(25.0)),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: ScreenUtil().setHeight(200),
        ),
      ),
    );

    final registerPage = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
        top: ScreenUtil().setHeight(20),
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
                width: ScreenUtil().setWidth(0.8), //width of the border
              ),
              highlightedBorderColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(20.0),
                  horizontal: ScreenUtil().setWidth(20.0),
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
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
        top: ScreenUtil().setHeight(30),
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/signin'),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(20.0),
                horizontal: ScreenUtil().setWidth(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "SIGN IN",
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
            image: AssetImage("assets/images/bg.jpg"),
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
              SizedBox(height: ScreenUtil().setHeight(12)),
              registerPage,
              loginPage
            ],
          ),
        ),
      ),
    );
  }
}
