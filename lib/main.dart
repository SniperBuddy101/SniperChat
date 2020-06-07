import 'package:flutter/material.dart';
import 'package:sniper_chat/constants.dart';
import 'package:sniper_chat/screens/loading_page.dart';
import 'package:sniper_chat/screens/welcome_screen.dart';
import 'package:sniper_chat/screens/login_screen.dart';
import 'package:sniper_chat/screens/registration_screen.dart';
import 'package:sniper_chat/screens/chat_screen.dart';
import 'package:sniper_chat/screens/chat_list.dart';
import 'package:sniper_chat/screens/new_user_chat.dart';


void main() => runApp(SniperChat());

class SniperChat extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(appBarTheme: AppBarTheme(color: kPrimaryColor)),
      routes: {
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ChatListScreen.id: (context) => ChatListScreen(),
        NewUserChatScreen.id: (context) => NewUserChatScreen(),
        LoadingPage.id: (context) => LoadingPage(),
      },
      initialRoute: LoadingPage.id,
    );

  }
}


