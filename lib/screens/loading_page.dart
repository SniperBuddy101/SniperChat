import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'chat_list.dart';

class LoadingPage extends StatefulWidget {

  static String id = "loadingPageScreen";

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String initialRoute;

  @override
  void initState() {
    super.initState();
  }


  Future<void> getUser()async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) {
      initialRoute = WelcomeScreen.id;
    } else {
      initialRoute = ChatListScreen.id;
    }
    Navigator.pushNamedAndRemoveUntil(context, initialRoute, (Route theRoute) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(future: getUser(),builder: (context, snapshot){
          if (snapshot.connectionState != ConnectionState.done){
            return CircularProgressIndicator();
          }else{
            return SizedBox();
          }
        }),
      ),
    );
  }
}

