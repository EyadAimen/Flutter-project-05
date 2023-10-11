// this widget listens to the auth to determine which screen will show

import 'package:chatting_app/authenticate_screen_switcher.dart';
import 'package:chatting_app/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    if(user == null){
      return const AuthenticateSwitcher();
    }
    else{
      // checking if the email is verfied
      return const IsVerified();
    }
  }
}