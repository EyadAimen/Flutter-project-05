import 'package:chatting_app/services/firebase/auth.dart';
import 'package:chatting_app/utils/components/login_components.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final Function switcher;
  const SignUpScreen({super.key,required this.switcher});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // these are controllers for the form fields
  // this one to get the state of the form
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passowrdController = TextEditingController();
  final TextEditingController _confirmPassowrdController = TextEditingController();

  // this is for the loading while wating for the sign up
  bool isLoadingVisible = false;
  // this is for the error if it couldnt create a user
  bool isErrorVisible = false;
  String _errorMessage = '';

  // this is for the firebase auth
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Sign up",style: appBarStyle,),
        toolbarHeight: 100,
      ),
      body: Container(
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
                // for the visibility widgets to indicate the sign up 
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // for the first name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _userNameController,
                      decoration: userNamelInputDecoration,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Username can not be empty";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                  ),
        
                  // for the last name
                  
        
                  // For the email
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _emailController,
                      decoration: emailInputDecoration,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
        
                  // for the password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _passowrdController,
                      decoration: passwordInputDecoration,
                      obscureText: true,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "The password cannot be empty";
                        }
                        else if(value.length< 8){
                          return "The password must be at least 8 characters long";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                  ),
        
                  // for the confirm password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _confirmPassowrdController,
                      decoration: confirmPasswordInputDecoration,
                      obscureText: true,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if(value != _passowrdController.text){
                          return "Passwords don`t match";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                  ),
        
                  // the sign up button
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
                        // to dismiss the keyboard
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                          }
                        // here will do the creation of a user if the form is valid
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            isLoadingVisible = true;
                            isErrorVisible = false;
                          });
                          dynamic result = await _authService.signUpWithEmailANDPassword(_emailController.text.trim(), _passowrdController.text, _userNameController.text.trim());
                          if(result == null){
                            setState(() {
                              _errorMessage = "something went wrong.. try again";
                              isErrorVisible = true;
                              isLoadingVisible = false;
                            });
                          }
                        }
                      },
                      child: const Text("Sign up",style: TextStyle(color: Colors.white,fontSize: 18),)
                      ),
                  ),
                  Row(
                    children: [
                      Text("Already have an account? ",style: TextStyle(fontSize: 15,color: Theme.of(context).colorScheme.onSurface),),
                      GestureDetector(
                        onTap: () {
                          widget.switcher();
                        },
                        child: Text("Log in",style: TextStyle(color: Colors.deepPurple[700],fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  Visibility(
                    visible: isLoadingVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: CircularProgressIndicator(color: Colors.deepPurple[700],),
                    ),
                    ),
                  Visibility(
                    visible: isErrorVisible,
                    child: Text(_errorMessage,style: const TextStyle(color: Colors.red,fontSize: 15),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}