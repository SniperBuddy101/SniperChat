import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sniper_chat/constants.dart';


class ChatBubbleColumn extends StatelessWidget {


  final String labelText, messageSender;
  final bool isMe;


  ChatBubbleColumn({this.labelText, this.messageSender, this.isMe});

  final BorderRadius b1 = BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0), topRight: Radius.circular(12.0));
  final BorderRadius b2 = BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0), topRight: Radius.circular(12.0));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(messageSender, style: TextStyle(color: Colors.black54, fontSize: 10.0),),
          Material(
            elevation: 6.0,
            borderRadius: isMe ? b1 : b2,
            color: isMe ? kPrimaryColor : Colors.greenAccent.shade700,
            child: Padding(
                padding:EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text(labelText, style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return labelText;
  }
}
