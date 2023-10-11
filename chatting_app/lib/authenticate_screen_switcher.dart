// this widget switch between the log in screen and sign uo screen

import 'package:chatting_app/screens/login_screen.dart';
import 'package:chatting_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthenticateSwitcher extends StatefulWidget {
  const AuthenticateSwitcher({super.key});

  @override
  State<AuthenticateSwitcher> createState() => _AuthenticateSwitcherState();
}

class _AuthenticateSwitcherState extends State<AuthenticateSwitcher> {


  // depending on this var it will switch
  //not using just push and pop between the 2 screens cuz of the use of the provider
  bool showSignIn = true;

  // this function will switch bettwen the screens
  void switcher(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      // adding this function as a parameter for both of the screens
      return LoginScreen(switcher: switcher);
    }
    else{
      return SignUpScreen(switcher: switcher);
    }
  }
}