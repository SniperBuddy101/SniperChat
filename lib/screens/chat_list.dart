import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sniper_chat/constants.dart';
import 'package:sniper_chat/screens/welcome_screen.dart';
import 'list_items.dart';
import 'new_user_chat.dart';

class ChatListScreen extends StatefulWidget {
  static String id = "chatListScreen";

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _users = Firestore.instance;
  List<Widget> listBuilderList = [];
  CollectionReference userReference;
  QuerySnapshot resultDocs;
  List chatList;
  bool chatListGetterSpinner = true;
  FirebaseUser user;
  bool builderVisibility = false;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async {
    user = await _auth.currentUser();
    userReference = _users.collection("user");
    setState(() {
      builderVisibility = true;
    });
  }

  Future chatListBuilder() async {
    listBuilderList = [];
    for (DocumentSnapshot eachDocument in chatList) {
      String userID = eachDocument.data['userID'];
      QuerySnapshot chatUserIDDocs = await userReference
          .where(FieldPath.documentId, isEqualTo: userID)
          .getDocuments();
      if (chatUserIDDocs.documents != []) {
        final String userName = chatUserIDDocs.documents[0].data['name'];
        final String chatID = eachDocument.data['chatID'];
        listBuilderList.add(ListBuilder(
          userName: userName,
          user: user,
          person2userID: userID,
          chatID: chatID,
        ));
      }
    }
  }

  Widget builderOrNo() {
    if (builderVisibility != true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream:
              userReference.document(user.uid).collection('chats').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              chatList = snapshot.data.documents;

              if (chatList.isNotEmpty) {
                return FutureBuilder(
                    future: chatListBuilder(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView(
                          children: listBuilderList,
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
                  color: kSecondaryColor,
                  child: Center(
                    child: Card(
                      color: kPrimaryColor,
                      elevation: 10.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Text(
                          "No chats found.\nAdd a chat to see it here.",
                          style:
                              TextStyle(color: kSecondaryColor, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Wanna exit the app?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Yes")),
                    FlatButton(onPressed: (){
                      Navigator.of(context).pop(false);
                    }, child: Text("No"))
                  ],
                );
              });
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewUserChatScreen(
                              user: user,
                            )));
              }),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
                    _auth.signOut();
                  })
            ],
            title: Text(
              "SniperChat",
            ),
          ),
          body: Container(
            child: builderOrNo(),
          ),
        ),
      ),
    );
  }
}
