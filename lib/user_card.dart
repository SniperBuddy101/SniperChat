import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sniper_chat/constants.dart';

class UserSearchCard extends StatelessWidget {
  final String userName;
  final bool hasIcon;
  final String userID;
  final String person2UserID;
  Firestore _firestore = Firestore.instance;
  final BuildContext usefulContext;

  UserSearchCard(
      {this.userName,
      this.hasIcon,
      this.userID,
      this.person2UserID,
      this.usefulContext});

  void addChat() {
    Navigator.pop(usefulContext);
    CollectionReference user1 =
        _firestore.collection('user').document(userID).collection('chats');
    CollectionReference user2 = _firestore
        .collection('user')
        .document(person2UserID)
        .collection('chats');

    DocumentReference chatIDreference =
        _firestore.collection('chats').document();
    String chatID = chatIDreference.documentID;
    _firestore
        .collection('chats')
        .document(chatID)
        .setData({'Chat Initialized': true});
    user1.add({"chatID": chatID, "userID": person2UserID, "isUser": true});
    user2.add({"chatID": chatID, "userID": userID, "isUser": true});
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimaryColor,
      elevation: 6.0,
      child: ListTile(
        leading: hasIcon
            ? Icon(
                Icons.perm_identity,
                color: kSecondaryColor,
              )
            : Icon(
                Icons.do_not_disturb,
                color: kSecondaryColor,
              ),
        title: (Text(userName, style: TextStyle(color: kSecondaryColor),)),
        trailing: hasIcon
            ? IconButton(
                icon: Icon(Icons.add, color: kSecondaryColor,),
                onPressed: () {
                  addChat();
                })
            : null,
      ),
    );
  }
}
