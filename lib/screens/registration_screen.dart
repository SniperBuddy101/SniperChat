import 'package:sniper_chat/constants.dart';
import 'package:sniper_chat/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registrationScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore fireStoreInstance = Firestore.instance;
  FirebaseUser currentUser;
  bool emailFieldNull = false;
  bool passwordFieldNull = false;
  bool nameFieldNull = false;

  String emailAddress, password, name;

  bool fieldChecker() {
    List fieldList = [
      [emailAddress, emailFieldNull],
      [password, passwordFieldNull],
      [name, nameFieldNull]
    ];
    bool isAnyFieldNull = false;
    for (List eachField in fieldList) {
      if (eachField[0] == null || eachField[0] == "") {
        if (fieldList.indexOf(eachField) == 0) {
          emailFieldNull = true;
        } else if (fieldList.indexOf(eachField) == 1) {
          passwordFieldNull = true;
        } else {
          nameFieldNull = true;
        }
        isAnyFieldNull = true;
      } else {
        if (fieldList.indexOf(eachField) == 0) {
          emailFieldNull = false;
        } else if (fieldList.indexOf(eachField) == 1) {
          passwordFieldNull = false;
        } else {
          nameFieldNull = false;
        }
      }
    }
    return isAnyFieldNull;
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
                name = value;
              },
              decoration: kInputDecoration.copyWith(
                  hintText: "Enter your name",
                  errorText: nameFieldNull
                      ? "Please enter a name. It can't be empty"
                      : null),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: kInputTextStyle,
              onChanged: (value) {
                emailAddress = value;
              },
              decoration: kInputDecoration.copyWith(
                  hintText: "Enter your email",
                  errorText: emailFieldNull
                      ? "Please enter an email address.\nIt can't be left empty."
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
                      ? "Password field can't be left unfilled.\nPlease enter the password"
                      : null),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Material(
                color: Colors.green.shade900,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    if (fieldChecker()) {
                      setState(() {});
                    } else {
                      try {
                        AuthResult authResult =
                            await _auth.createUserWithEmailAndPassword(
                                email: emailAddress, password: password);
                        currentUser = await _auth.currentUser();
                        DocumentReference documentReference = fireStoreInstance
                            .collection("user")
                            .document(currentUser.uid);
                        await documentReference.setData(
                            {"emailAddress": currentUser.email, "name": name});
                        if (authResult != null) {
                          Navigator.pushNamed(context, ChatListScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
