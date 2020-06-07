import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sniper_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_bubbles.dart';
import 'package:async/async.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chatScreen";

  final FirebaseUser user;

  final String person2userID;
  final String person2UserName;
  final String chatID;

  ChatScreen({this.person2userID, this.person2UserName, this.chatID, this.user});



  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String messageText;
  Firestore _message = Firestore.instance;
  final TextEditingController textController = TextEditingController();
  FirebaseUser user;
  String docID;
  DocumentReference documentReference;

  @override
  void initState() {
    super.initState();
    userSetter();

  }

  void userSetter(){
    user = widget.user;
  }


  void documentAdder(){
    docID = widget.chatID;
    documentReference = _message.collection('chats').document(docID);

  }




  @override
  Widget build(BuildContext context) {

    documentAdder();

    return Scaffold(
      appBar: AppBar(
        title: Text('️Chat with ${widget.person2UserName}'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: documentReference.collection('messages').orderBy('timestamp').snapshots(),
                  builder: (context, snapshot){
                    if (!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }else{
                      final List<ChatBubbleColumn> chatBubbleList = [];
                      final messages = snapshot.data.documents.reversed;
                      for (var i in messages) {
                        final String textMessage = i.data["text"] ?? "Blank text";
                        final String messageUser = i.data["sender"];
                        final String senderEmail = i.data['senderEmail'];
                        final bool isMe = user.uid == messageUser;
                        final messageBubble = ChatBubbleColumn(
                            labelText: textMessage,
                            messageSender: senderEmail,
                            isMe: isMe);
                        chatBubbleList.add(messageBubble);
                      }

                      return ListView(
                        reverse: true,
                        children: chatBubbleList,
                      );
                    }

                  }),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      documentReference.collection('messages').add({'receiver': widget.person2userID, 'sender': user.uid, 'text': messageText, 'senderEmail': user.email,
                      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch});

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

