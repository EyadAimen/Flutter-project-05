import 'package:chatting_app/screens/change_password.dart';
import 'package:chatting_app/services/firebase/auth.dart';
import 'package:chatting_app/utils/components/login_components.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  final Function switcher;
  const LoginScreen({super.key,required this.switcher});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // for the form state
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passowrdController = TextEditingController();

  bool isLoadingVisible = false;
  // this is for the error if it couldnt create a user
  bool isErrorVisible = false;
  String _errorMessage = '';

  // for the firebase
  final AuthService _authService = AuthService();

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in",style: appBarStyle),
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration:  BoxDecoration(
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // For the email
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
        
                  // for the password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      controller: _passowrdController,
                      decoration: passwordInputDecoration,
                      obscureText: true,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
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
        
                  // the login button
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 102, 60, 199),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton(
                      onPressed: () async{
                        // to dismiss the keyboard
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                          }
                        if(_formKey.currentState!.validate()){
                          // just to show the loading widget
                          setState(() {
                            isLoadingVisible = true;
                            isErrorVisible = false;
                          });
                          dynamic result = _authService.signInWithEmailANDPassword(_emailController.text.trim(), _passowrdController.text);
                          if(result == null){
                            setState(() {
                              isErrorVisible = true;
                              _errorMessage = "Invalid Email or password";
                              isLoadingVisible = false;
                            });
                          }
                        }
                      },
                      child: const Text("Log In",style: TextStyle(color: Colors.white,fontSize: 18,),)
                      ),
                  ),
        
                  // to navigate to sign up page 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Text("Don`t have an account? ",
                        // i gave it a color because whn the theme changes it still at the color black
                        // did it multiple times in the file
                        style: TextStyle(
                          fontSize: 15,color: Theme.of(context).colorScheme.onSurface,
                        ),),
                        GestureDetector(
                          onTap: (){
                            widget.switcher();
                          },
                          child: const Text("Sign Up",style: TextStyle(color: Color.fromARGB(255, 102, 60, 199),fontSize: 16,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()));
                    },
                    child: const Text("Forgot Password?",style: TextStyle(color: Color.fromARGB(255, 102, 60, 199),fontSize: 16,fontWeight: FontWeight.bold),)
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