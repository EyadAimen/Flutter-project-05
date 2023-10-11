import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key,required this.name,required this.uid,required this.token,required this.notification,required this.imageUri});
  final String name;
  final String uid;
  final String token;
  final bool notification;
  final String imageUri;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for the visibily widget
  bool isVisible = false;
  // for the Text Field
  final TextEditingController _messageController = TextEditingController();
  // the scroll controller so when u add a message it will animate to the last added item
  late ScrollController _scrollController;

  // for the keyboard so the screen go up 
  // and it behaves like the whatsapp one
  bool isKeyboardVisible = false;
  // for notification
  String notificationMessage = '';

  // for accessing the current user id
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  final player = AudioPlayer();

  String _currentUserName = '';
  String _currentUserToken = '';
  String _currentUserImageUri = '';
  bool _currentUserNotificationStatus = false;
  
  getCurrentUsersData() async{
   var doc =  _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid);
   await doc.get().then((value){
        Map<String,dynamic> data = value.data() as Map<String,dynamic>;
          _currentUserName = data['userName'];
          _currentUserToken = data['token'];
          _currentUserNotificationStatus = data['notificationStatus'];
          _currentUserImageUri = data['pic'];

    });
  }
  bool isPic = false;
  String imageUri = '';
  late final Reference _firebaseStorageImage = FirebaseStorage.instance.ref('avatar/${widget.uid}');
  getProfilePic() async{
      if( isPic == true){ 
      imageUri = await _firebaseStorageImage.getDownloadURL();
      setState(() {
        imageUri = imageUri;
      });
      }
  }

  // getProfilePicValue(){
  //   _databaseAppFunctions.usersCollection.doc(widget.uid).get().then((value){
  //     Map<String,dynamic> data = value.data() as Map<String,dynamic>;
  //     setState(() {
        
  //       isPic = data['pic'];
  //     });
  //     getProfilePic();
  //   });
  // }

  @override
  void initState() {
    // getProfilePicValue();
    getCurrentUsersData();
    // for the scroll conteroller
    _scrollController = ScrollController();
    
    // listens for the keyboard visibility
    KeyboardVisibilityController().onChange.listen((bool visible) { 
      setState(() {
        isKeyboardVisible = visible;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // called this function to avoid the error
  // which happens when calling someting from the network
  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          onPressed: () {
            // to dismiss the keyboard
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              }
            Navigator.pop(context);
          },
        ),
        title: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: colorSelector(widget.name[0]),
            backgroundImage: widget.imageUri!=""?  CachedNetworkImageProvider(widget.imageUri) : null,
            child: widget.imageUri== ""? Text(widget.name[0],style: appBarStyle): null,
          ),
          title: Text(widget.name,style: appBarStyle,overflow: TextOverflow.ellipsis,),
        ),
        toolbarHeight: 100,
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _databaseAppFunctions.messagesListCollection.doc(widget.uid).collection("messages").orderBy("date",descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                      
                      // this is for the keyboard to collapse when scrolling
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      
                      // this controller is used for when senting a message the focus will be on the last
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      itemCount: snapshot.data?.docs.length,
                      
                      itemBuilder: (context,index){
                        
                      
                          // this will get the message doc
                          Map<String, dynamic> messageData = snapshot.data!.docs[index].data();
                          // fonverting the TimesTamp to a datetime obj so i can display the hours and mins
                          Timestamp firestoreTimestamp = messageData['date'];
                          DateTime dateTime = firestoreTimestamp.toDate();
                          String hour = dateTime.hour<10? "0${dateTime.hour}" : "${dateTime.hour}";
                          String minute = dateTime.minute<10? "0${dateTime.minute}" : "${dateTime.minute}";
                          // to get the am and pm of the message
                          String amPm = dateTime.hour>12? "PM" : "AM";
                          String message = messageData['message'];
                          
                        
                          return GestureDetector(
                            // to copy the 
                            onLongPress: () {
                              FlutterClipboard.copy(message).then((value){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Copied.."),
                                  duration: Duration(seconds: 1),
                                  ));
                                });
                            },
                            child: UnconstrainedBox(
                                // this will determine which message sent from you or the other user
                                // its used also to determine the container color
                                
                                alignment: messageData['from'] != _databaseAppFunctions.currentUser!.uid? Alignment.centerLeft : Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  
                                  constraints: BoxConstraints(
                                    minHeight: 50,
                                    
                                    maxWidth: MediaQuery.of(context).size.width*0.7
                                  ),
                                  decoration: BoxDecoration(
                                    color: messageData['from'] != _databaseAppFunctions.currentUser!.uid? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // i changed the color because when the theme changes only here and the login screen
                                      // the color stays black idk why

                                      // if the message is a link it can launch it
                                      message.startsWith("https://")?GestureDetector(
                                        onTap: () async{
                                          // launchUrl(message,);
                                          final link = Uri.parse(message);
                                          if(await canLaunchUrl(link)){
                                            launchUrl(link,mode: LaunchMode.externalApplication);
                                          }
                                          else{
                                            if(context.mounted){
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("can not open the link"),
                                              backgroundColor: Colors.red,
                                              )
                                            );
                                            }
                                          }
                                        },
                                        child: Text(message,style: urlMessagesStyle,),
                                      ) 
                                      : Text(messageData['message'],style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),),
                                      Text("$hour:$minute $amPm",style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 12,
                                      ),),
                                    ],
                                  ),
                                ),
                                                  ),
                          );
                        
                        }
                          
                       
                      );
                      
                    }
                    
                      else if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(color: Colors.deepPurple[700],),);
                        }
                        
                        else if(!snapshot.hasData){
                          return const Center(child: Text("Add messages"),);
                        }
                        else if(snapshot.hasError){
                          return const Center(child: Text("Something went wrong!, go back and open the chat again"),);
                        }
                        // i return visibility because i cant return null
                        else {
                          return Visibility(
                            visible: false,
                            child: Container(),
                          );
                        }
                    
                  }
                ),
              ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          // i did it like this so the textfield can expan to its maxlines property
                          constraints: const BoxConstraints(
                            minHeight: 50
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(style: BorderStyle.solid,width: 2,color: Theme.of(context).scaffoldBackgroundColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                
                          child: TextField(
                            expands: false,
                            maxLines: 5,
                            minLines: 1,
                            controller: _messageController,
                            onChanged: (value) {
                              if(value.isNotEmpty){
                                if(value.trim() != ""){
                                  setState(() {
                                  isVisible = true;
                                });
                                }
                                else{
                                  setState(() {
                                  isVisible = false;
                                });
                                }
                              }
                              
                              else{
                                setState(() {
                                  isVisible = false;
                                });
                              }
                            },
                            // i changed the color because when the theme changes only here and the login screen
                            // the color stays black idk why
                           style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                           keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              
                              contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none),
                              hintText: "Send a message"
                            ),
                          ),
                        ),
                      ),
                      // i did it like this because i couldnt find a way to animate the size of an expanded widget
                      // so i wrapped this visibiltie widget with animation for both opacity and size so in can create a good animation

                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: isVisible? 1 : 0,
                            child: Visibility(
                              visible: isVisible,
                              maintainState: true,
                              maintainAnimation: true,
                              child: MaterialButton(
                                
                                onPressed: () {

                                  // here to add the message for both the current user and the other user
                                  try{
                                    _databaseAppFunctions.messagesListCollection.doc(widget.uid).collection("messages").add({
                                    "message": _messageController.text,
                                    "from": _databaseAppFunctions.currentUser!.uid,
                                    "date": Timestamp.now(),
                                  });
                                  _databaseAppFunctions.usersCollection.doc(widget.uid).collection("messagesList").doc(_databaseAppFunctions.currentUser!.uid).collection("messages").add({
                                    "message": _messageController.text,
                                    "from": _databaseAppFunctions.currentUser!.uid,
                                    "date": Timestamp.now(),
                                  }).then((value){

                                    // for sending a notification
                                    sendNotification(widget.token,notificationMessage,_currentUserName,_databaseAppFunctions.currentUser!.uid);
                                    // playing sound for the sent message
                                    player.play(AssetSource("message_sent_sound_effect.mp3"));
                                  });
                                  }catch (e){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Failed to send the message...",style: TextStyle(color: Colors.red),),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  


                                  setState(() {
                                    notificationMessage = _messageController.text;
                                    _messageController.text = '';
                                    isVisible = false;
                                    
                                  });
                                  _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                },
                                height: 50,
                                minWidth: 0,
                                elevation: 0,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                shape: const CircleBorder(side: BorderSide.none),
                                child: const Icon(Icons.send,color: Colors.white,size: 16,),
                                ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        
      ),
    );
  }

  // sending notification to other user
  Future<void> sendNotification(String token,String body,String userName,String id) async{
    var serverKey = 'AAAArpCNK3k:APA91bHKJW1dmXtDJ3HDJaSz8MUJBCWXSubbInvP3SD_BWNdBMSonSYRW2tJEQJEU6Bl0esBZqoQNo4gAedbeEh-usR0ib64E0cAkT9TYJiiUxqVaNRvad4CFrsCARQ2COUOJ7FKFUzl';
    var jsonData = jsonEncode({
      'notification' : <String,dynamic>{
              'title': userName,
              'body': body,
            },
            'data' : <String,dynamic>{
              'id': id,
              'token': _currentUserToken,
              'notificationStatus': _currentUserNotificationStatus,
              'pic': _currentUserImageUri,
            },
            'to': token,
    });
    await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey'
        },
        body: jsonData,
        
      );
  }

 }