import 'package:sniper_chat/constants.dart';
import 'package:sniper_chat/screens/chat_list.dart';
import 'package:sniper_chat/screens/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool spinnerBool = false;
  String emailAddress, password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool emailFieldNull = false;
  bool passwordFieldNull = false;

  bool fieldChecker(){
    List fieldList = [[emailAddress, emailFieldNull], [password, passwordFieldNull]];
    bool isAnyFieldNull = false;
    for (List eachField in fieldList){

      if (eachField[0] == null || eachField[0] == ""){

        if (fieldList.indexOf(eachField) == 0){
          emailFieldNull = true;
        }else{
          passwordFieldNull = true;
        }
        isAnyFieldNull = true;

      }else{
        if (fieldList.indexOf(eachField) == 0){
          emailFieldNull = false;
        }else{
          passwordFieldNull = false;
        }
      }
    }
    return isAnyFieldNull;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinnerBool,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logoTag",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: kInputTextStyle,
                onChanged: (value) {
                  emailAddress = value;
                },
                decoration: kInputDecoration.copyWith(
                    hintText: "Enter your email",
                    errorText: emailFieldNull
                        ? "Please enter an email address"
                        : null),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: kInputTextStyle,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputDecoration.copyWith(
                    hintText: "Enter your password",
                    errorText: passwordFieldNull
                        ? "Password field cannot be empty"
                        : null),
              ),
              SizedBox(
                height: 24.0,
              ),
              ReusableButton(
                colorProperty: kPrimaryColor,
                labelText: "Log in",
                onPressProperty: () async {

                  if(fieldChecker()){

                    setState(() {

                    });

                  }else {

                    setState(() {
                      emailFieldNull = false;
                      passwordFieldNull = false;
                      spinnerBool = true;
                    });
                    try {
                      AuthResult user = await _auth.signInWithEmailAndPassword(
                          email: emailAddress, password: password);
                      if (user != null) {
                        FirebaseUser user = await _auth.currentUser();
                        Navigator.pushNamed(context, ChatListScreen.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      spinnerBool = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
