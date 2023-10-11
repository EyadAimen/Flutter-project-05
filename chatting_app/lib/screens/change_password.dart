import 'package:chatting_app/utils/components/login_components.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Change Password",style: appBarStyle,),
          toolbarHeight: 100,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ),

        body: Container(
        padding: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Enter your email and will send you reset password link",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16
                  ),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _emailController,
                      decoration: emailInputDecoration,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      // this is before it looks for the accoun in the firebase
                      // to check if its in the email form
                      validator: (value) {
                        RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-zA-Z0-9+_.-]");
                        if (value!.isEmpty) {
                          return "Enter an email";
                        }
                        else if (!regex.hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 102, 60, 199),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: TextButton(
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          resetPassword(_emailController.text);
                        }
                      },
                      child: const Text("Reset password",style: TextStyle(color: Colors.white,fontSize: 18,),)
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
    );
  }

  Future resetPassword(String email) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: _emailController.text.trim());
      if(context.mounted){
        showDialog(
        context: context, 
        barrierDismissible: true,
      builder: (_)=> AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text("An email sent to ${_emailController.text}.. follow the link to reset your password",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16
          ),),
      ),
      ); 
      }
                         
    }on FirebaseAuthException catch(e){
      if(context.mounted){
        showDialog(
        context: context,
        barrierDismissible: true,
      builder: (_)=> AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text(e.message.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16
          ),),
      ),
      ); 
      }
      
    }
  }
}