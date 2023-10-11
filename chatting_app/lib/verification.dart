import 'dart:async';
import 'package:chatting_app/screens/pages_controller.dart';
import 'package:chatting_app/services/firebase/auth.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IsVerified extends StatefulWidget {
  const IsVerified({super.key});

  @override
  State<IsVerified> createState() => _IsVerifiedState();
}

// here is checks if the user verified or not
class _IsVerifiedState extends State<IsVerified> {
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  // timer to check for the verification state
  Timer? timer;
  bool isEmaliVerified = false;

  // here will send a verification email
  sendEmailVerification(){
      try{
        _databaseAppFunctions.currentUser!.sendEmailVerification();
        
      }on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()),
        backgroundColor: Colors.red,));
      }
    }

  // here checks for the verification state every 3seconds
  checkEmailVerification() async{
    await _databaseAppFunctions.currentUser!.reload();
    setState(() {
      isEmaliVerified = _databaseAppFunctions.currentUser!.emailVerified;
    });
  }    


  @override
  void initState() {
    isEmaliVerified = _databaseAppFunctions.currentUser!.emailVerified;

    
    if(!isEmaliVerified){
      sendEmailVerification();
      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerification()
    );
    }

    if(isEmaliVerified) timer?.cancel();


    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
   
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isEmaliVerified? const AllPages()
    :Scaffold(
      appBar: AppBar(
        title: const Text("Email Verifiaction",style: appBarStyle,),
        toolbarHeight: 100,
        ),

        body: Container(
          padding: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Verifiaction email sent",style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 102, 60, 199),
                  borderRadius: BorderRadius.circular(30)
                  ),
                child: TextButton(
                  child: const Text("Resend Email",
                  style: TextStyle(color: Colors.white,fontSize: 18,),),
                  onPressed: () {
                    sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification Email sent")));
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 102, 60, 199),
                  borderRadius: BorderRadius.circular(30)
                  ),
                child: TextButton(
                  child: const Text("Go back",
                  style: TextStyle(color: Colors.white,fontSize: 18,),),
                  onPressed: () {
                    AuthService().signOut();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("when you are verified reset the app",style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
              ),
            ],
          ),
        ),
        ),
    );
  }
}