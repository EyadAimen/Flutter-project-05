import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/screens/change_password.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/services/firebase/firestore.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:flutter/material.dart';


class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen>{


  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  late final _currentUserId = _databaseAppFunctions.currentUser!.uid;
  // for the textField state
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  

  

  

  @override
  void initState() {
    
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
          title: const Text("Account Details",style: appBarStyle,),
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).snapshots(),
              builder: (context,snapshot) {
                var userName = snapshot.data;
                String imageUri = userName?['pic']?? "";
                if(snapshot.hasData){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                            builder: (context)=> const ChangeProfilePic(),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: colorSelector(userName!["userName"]),
                            backgroundImage:imageUri!=""?  CachedNetworkImageProvider(imageUri) : null,
                             child: imageUri== ""? Text(userName["userName"][0].toUpperCase(),style: appBarStyle): null,
                            
                          ),
                        ),
                        Text(userName["userName"],style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 18,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  );
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(color: Colors.deepPurple[700],),);
                }
                else if(snapshot.hasError){
                  return Center(child: Text("Something went wrong!",style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 18,fontWeight: FontWeight.w600),),);
                }
                else{
                  return Container();
                }
              }
            ),
            StreamBuilder(
              stream: _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).snapshots(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  var userName = snapshot.data;
                  var currentUserName = userName!["userName"];
                  
                  // wrapped with from because of using the validator
                  return Form(
                    key: _formKey,
                    child: ListTile(
                    leading: const Text("Username:",style: nameStyle,),
                    title: TextFormField(
                      style:TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface)),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      textInputAction: TextInputAction.done,
                      controller: _userNameController,
                      
                      onChanged: (value) {
                        setState(() {
                          _userNameController.text = value;
                        });
                      },
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Username can not be empty";
                          }
                        else{
                          return null;
                          }
                      },
                      
                    ),
                    trailing: TextButton(
                      child: Text("Change",style: TextStyle(color: Colors.deepPurple[700]),),
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          try{
                            _databaseAppFunctions.usersCollection.doc(_currentUserId).update({
                            "userName": _userNameController.text.trim(),
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Username changed from $currentUserName to ${_userNameController.text}",
                              style: const TextStyle(color: Colors.white),),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                              
                            ),
                          );
                          });

                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Unable to change Username",
                              style: TextStyle(color: Colors.white),),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              
                            ),
                          );
                          }
                          
                          
                        }
                      },
                    ),
                   ),
                  );
                }
                else{
                  return const Visibility(visible: false,child: Text(""),);
                }
              }
            ),

            ListTile(
              title: const Text("Change Password",style: nameStyle,),
              leading: const Icon(Icons.key,),
              trailing: const Icon(Icons.arrow_forward_ios,),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}