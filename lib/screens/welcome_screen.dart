import 'package:flutter/material.dart';
import 'package:sniper_chat/constants.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'reusable_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcomeScreen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
//  AnimationController controller;
//  Animation colorTween;

  @override
  void initState() {
    super.initState();

//    controller = AnimationController(
//      duration: Duration(seconds: 1),
//      vsync: this,
//    );
//
//    colorTween = ColorTween(begin: Colors.lightBlue, end: Colors.white)
//        .animate(controller);
//
//    controller.forward();
//
//    colorTween.addListener(() {
//      setState(() {});
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logoTag",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Expanded(
                  child: TextLiquidFill(text: "SniperChat",
                  waveColor: Colors.black,
                  boxBackgroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w900),
                  boxHeight: 100.0,),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableButton(
              labelText: "Log in",
              onPressProperty: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              colorProperty: kPrimaryColor,
            ),
            ReusableButton(labelText: "Register", colorProperty: Colors.green.shade900,
            onPressProperty: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}
