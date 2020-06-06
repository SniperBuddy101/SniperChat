import 'package:flutter/material.dart';
import 'package:sniper_chat/constants.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListBuilder extends StatelessWidget {
  final String userName;
  final FirebaseUser user;
  final String person2userID;
  final String chatID;

  ListBuilder(
      {@required this.userName, this.user, this.person2userID, this.chatID});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        color: Colors.white,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          person2userID: person2userID,
                          person2UserName: userName,
                          chatID: chatID,
                          user: user,
                        )));
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.perm_identity, color: kPrimaryColor,),
                ),
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.black45, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
