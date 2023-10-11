import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/screens/account_details.dart';
import 'package:chatting_app/services/firebase/auth.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with AutomaticKeepAliveClientMixin<Settings>{
  @override
  bool get wantKeepAlive => true;
  
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  
  

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",style: appBarStyle,),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).get(),
                builder: (context,snapshot) {
                  if(snapshot.hasData){
                    var data = snapshot.data;
                    var userName = data?['userName'];
                    String imageUri = data?['pic']?? "";
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: colorSelector(userName),
                            backgroundImage:imageUri!=""?  CachedNetworkImageProvider(imageUri) : null,
                            child: imageUri== ""? Text(userName[0].toUpperCase(),style: appBarStyle): null,
                          ),
                          Text(userName,style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 18,fontWeight: FontWeight.w600),),
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
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    leading: const Icon(Icons.person,),
                    title:const Text("Account Details",style: nameStyle,),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AccountDetailsScreen()));
                    }
                  ),
                ),
              Material(
                type: MaterialType.transparency,
                child: ListTile(
                  leading: const Icon(Icons.logout,),
                  title:const Text("Sign out",style: nameStyle,),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      
                      builder: (_)=> AlertDialog(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        title: const Text("Sign out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),),
                        content: const Text("Are you sure you want to sign out?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                        actions: [
                        TextButton(
                          child: const Text("Yes",style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            AuthService().signOut();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(signOutSnackBar);
                          },
                        ),
                        TextButton(
                          child: const Text("No",style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        ],
                      )
                    );
                    }
                  ),
              ),
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                  leading: const Icon(Icons.notifications,),
                  title:const Text("Notification settings",style: nameStyle,),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async{
                    await Permission.notification.request().then((value) {
                      if(value.isGranted){
                      _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).update({
                        "notificationStatus": true,
                        }).then((value){
                          try{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("notifications are allowed",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Could`nt update notification settings",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        });
                      }
                    else if(value.isDenied){
                      _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).update({
                        "notificationStatus": false,
                        }).then((value) {
                          try{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("notifications are denied",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Could`nt update notification settings",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            
                          }
                        });
                      }
                      else if(value.isPermanentlyDenied){
                        ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Open settings to allow notification",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                      }
                    });
                    
                    }
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  final signOutSnackBar = const SnackBar(
    content: Text("signed out.."),
    duration: Duration(seconds: 3),
    dismissDirection: DismissDirection.down,
  );
}