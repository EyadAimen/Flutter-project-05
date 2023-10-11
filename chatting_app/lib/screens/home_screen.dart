import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/screens/chat_screen.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// this is the screen that contains the added users or the users have been messaged
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// AutomaticKeepAliveClientMixin is used so the page doesnt reolad everytime the user navigate to it
class _HomeScreenState extends State<HomeScreen>  with AutomaticKeepAliveClientMixin<HomeScreen>{
  @override
  bool get wantKeepAlive => true;
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();

  // this gets the messagesList collection for the current user
  late CollectionReference messagesList = _databaseAppFunctions.messagesListCollection;
  // this refers to all the users collection to get the user id from the messages list and get it from this collection
  // it will just retrieve the username from it
  late CollectionReference usersData = _databaseAppFunctions.usersCollection;

  late final _firebaseStorageImage = FirebaseStorage.instance;
  bool isPic = false;


  getProfilePic(String id, bool isPic,) async{
    if( isPic == true){
      Reference ref = _firebaseStorageImage.ref("avatar/$id");
      String imageUri = await ref.getDownloadURL();
      setState(() {
        imageUri = imageUri;
      });
      }
  }
  
  // for the cloud messaging notification when the app is fully closed
  initialMessage() async{
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if(message != null){
      bool notificationStatus = await message.data['notificationStatus']=="false"? false : true;
      if(context.mounted){
        Navigator.push(context, 
        MaterialPageRoute(builder: (context)=>ChatScreen(name: message.notification!.title.toString(), uid: message.data['id'], token: message.data['token'], notification: notificationStatus, imageUri: message.data['pic'],))
        );
      } 
       
    }
  }

  @override
  void initState() {
    // for the cloud messaging notification when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      bool notificationStatus = await message.data['notificationStatus']=="false"? false : true;
      // when the user tap on the notification it will navigate to the chat screen with the user sent the message to them
      if(context.mounted){
        Navigator.push(context, 
        MaterialPageRoute(builder: (context)=>ChatScreen(name: message.notification!.title.toString(), uid: message.data['id'], token: message.data['token'], notification: notificationStatus, imageUri: message.data['pic'],))
        );
      }
     });
    initialMessage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chats",style: appBarStyle,),
          toolbarHeight: 100,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: StreamBuilder(
            
            stream: messagesList.snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                
                return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,index){
                  // here it has the added user uid to retrieve the data from the users collection
                  String? userIdInMessagesList = snapshot.data?.docs[index].id;
                  
                  // this is the document of the user from the userUidInMessagesList
                  DocumentReference addedUseruid = usersData.doc(userIdInMessagesList);
                  
                  // i used  a future builder here to get the added user data from the users collection
                  // i couldnt retrieve it in the same stream builder so i had to do it inside a future builder
                  return FutureBuilder(
                    future: addedUseruid.get(),
                    builder: (context,snapshot) {
                      var data = snapshot.data;
                      String imageUri = data?['pic']?? '';
                      
                      return Material(
                        type: MaterialType.transparency,
                        child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(name: data?['userName'],uid: userIdInMessagesList.toString(), token: data?['token'], notification: data?['notificationStatus'], imageUri: imageUri,)));
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: colorSelector("${data?['userName'][0]??'Loading..'}"),
                              backgroundImage: imageUri!=""?  CachedNetworkImageProvider(imageUri) : null,
                              child: imageUri == ''? Text("${data?['userName'][0]??'Loading..'}".toUpperCase(),style: appBarStyle): null,
                            ),
                            title: Text("${data?['userName']??'Loading..'}",style: nameStyle,overflow: TextOverflow.ellipsis,),
                        
                            // stream builder to get the last added message
                            subtitle: StreamBuilder(
                              stream: _databaseAppFunctions.messagesListCollection.doc(userIdInMessagesList).collection('messages').orderBy("date",descending: true).snapshots(),
                              builder: (context, snapshot) {
                                
                                if(snapshot.hasData){
                                  try{
                                    Map<String,dynamic> data = snapshot.data?.docs[0].data() as Map<String,dynamic>;
                                    return Text(data['message'], style: subtitleStyle,overflow: TextOverflow.ellipsis,);
                                  }catch (e){
                                    return const Text("");
                                  }
                                    
                                  
                                  
                                }
                                if(!snapshot.hasData){
                                  return const Text("");
                                }
                                if(snapshot.hasError){
                                  return const Text("");
                                }
                        
                                else{
                                  return const Text("");
                                }
                              },
                            ),
                          ),
                      );
                    }
                  );
                }
                );
                
              }
              if(snapshot.hasError){
                return const Center(child: Text("Something went wrong!",style: nameStyle));
              }
              
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple[700],));
              }
              
              return const Center(child: Text("Add friends",style: nameStyle,));  
            }
          ),
        ),
      );
  }
}