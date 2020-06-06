import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sniper_chat/constants.dart';
import 'package:sniper_chat/user_card.dart';

class NewUserChatScreen extends StatefulWidget {
  static String id = 'newUserChatScreen';
  final FirebaseUser user;

  NewUserChatScreen({this.user});

  @override
  _NewUserChatScreenState createState() => _NewUserChatScreenState();
}

class _NewUserChatScreenState extends State<NewUserChatScreen> {
  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  CollectionReference _users;
  String emailEntered;
  bool futureBuilderVisible = false;
  CollectionReference _chats;
  bool isFieldNull = false;

  Future userSearch() async {
    if (user.email == emailEntered) {
      return UserSearchCard(hasIcon: false, userName: "You can't chat with yourself mate, Or can you?",);
    }


    _users = _firestore.collection('user');
    var userDetails = await _users
        .where('emailAddress', isEqualTo: emailEntered)
        .getDocuments();
    if (userDetails.documents.isEmpty) {
      return UserSearchCard(hasIcon: false, userName: "No users found with the provided email.",);
    } else {
      String userID = user.uid;
      String person2UserID = userDetails.documents[0].documentID;
      CollectionReference userChats = _users.document(userID).collection('chats');
      QuerySnapshot chatList = await userChats.where("userID", isEqualTo: person2UserID).getDocuments();
      if (chatList.documents.isNotEmpty){
        return UserSearchCard(hasIcon: false, userName: "User already exists in your chat list.",);
      }
      if (userID == person2UserID) {
        return Text("You can't chat with yourself..");
      } else {
        var userMap = userDetails.documents[0].data;
        String userName = userMap['name'];
        return UserSearchCard(usefulContext: context ,hasIcon: true, userName: userName, userID: userID, person2UserID: person2UserID,);
      }
    }
  }

  void userSetter() {
    user = widget.user;
  }

  @override
  void initState() {
    super.initState();
    userSetter();
  }

  Widget futureBuilder() {
    if (!futureBuilderVisible) {
      return SizedBox();
    } else {
      return FutureBuilder(
          future: userSearch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        title: Text("Add a new chat"),
      ),
      body: Container(
        color: kSecondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Container()),
            TextField(
              onChanged: (value) {

                emailEntered = value;

                },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                errorText: isFieldNull ? "Please enter some text" : null,
                hintText: "Enter the user's email address",
                hintStyle: TextStyle(color: Colors.black45),
                fillColor: kSecondaryColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kPrimaryColor, width: 6.0)),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 85.0),
              height: 50.0,
              child: FlatButton(
                onPressed: () {
                  if (emailEntered == null || emailEntered == ""){
                    setState(() {
                      isFieldNull = true;
                      futureBuilderVisible = false;
                    });

                  }else {
                    setState(() {
                      isFieldNull = false;
                      futureBuilderVisible = true;
                    });
                  }
                },
                child: Text(
                  "SEARCH",
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            futureBuilder(),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }
}

