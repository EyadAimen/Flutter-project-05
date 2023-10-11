import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/screens/chat_screen.dart';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:chatting_app/utils/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsSearch extends StatefulWidget {
  const FriendsSearch({super.key});

  @override
  State<FriendsSearch> createState() => _FriendsSearchState();
}

class _FriendsSearchState extends State<FriendsSearch> with AutomaticKeepAliveClientMixin<FriendsSearch>{
  @override
  bool get wantKeepAlive => true;
    // for the search textField
  final TextEditingController _searchController = TextEditingController();
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  Timestamp date = Timestamp.now();
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(style: BorderStyle.solid,width: 2,color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              
              controller: _searchController,
              // i changed the color because when the theme changes only here and the login screen
              // the color stays black idk why
              style: const TextStyle(color: Colors.white,),
              onChanged: (value) {
                setState(() {
                  _searchController.text = value;
                });
              },
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                
                contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none),
                hintText: "Search for friends",
                hintStyle: const TextStyle(color: Colors.white),
                ),
                cursorColor: Colors.white,
              ),
            ),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: StreamBuilder(
          stream: _databaseAppFunctions.usersCollection.snapshots(),
          builder: ((context, snapshot) {
              // if there was an error it will display this message
              if(snapshot.error != null){
              return Center(child: Text("Something went wrong!",style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 18,fontWeight: FontWeight.w600),),);
            }
            // here if it has data and nothing went wrong the results will show
            else if(snapshot.hasData){
              // depending on the search textField controller it will show the results
            if(_searchController.text.isEmpty){
              return Center(child: Text("Search for Friends",style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 18,fontWeight: FontWeight.w600),),);
            }
            else{
              return ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,index){
                  String? docID = snapshot.data?.docs[index].id;
                  Map<String, dynamic> data = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  if(data['userName'].toString().toLowerCase().contains(_searchController.text.trim().toLowerCase()) && docID!= _databaseAppFunctions.currentUser!.uid){
                    String imageUri = data['pic']?? "";
                    return  ListTile(
                      onTap: () async{
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                        }
                        // to check if the user already exists or not
                        bool exists = await _databaseAppFunctions.messagesListCollection.doc(docID).get().then((value){
                        if(value.exists){
                          return true;
                        }
                        else{
                          return false;
                        }
                      });  

                      if(exists==false){
                        _databaseAppFunctions.messagesListCollection.doc(docID).set({
                          "friend": true,
                        });
                        _databaseAppFunctions.usersCollection.doc(docID).collection("messagesList").doc(_databaseAppFunctions.currentUser!.uid).set({
                          "friend": true,
                        });
                      }
                      if(context.mounted){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(name: "${data['userName']}",uid: docID.toString(), token: data['token'], notification: data['notificationStatus'], imageUri: imageUri,)));
                      }
                    },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: colorSelector("${data['userName'][0]}"),
                        backgroundImage: imageUri!=""?  CachedNetworkImageProvider(imageUri) : null,
                        child: imageUri ==''? Text("${data['userName'][0]}".toUpperCase(),style: appBarStyle) : null,
                      ),
                      title: Text("${data['userName']}",style: nameStyle,overflow: TextOverflow.ellipsis,),
                      );
                  }
                  // i did this because when its 
                  // return null;
                  // the search didnt work for me
                  return Visibility(visible: false,child: Container(),);
                  
                  }
                  
                );
            }
              
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple[700],));
              }
              else{
                return Container();
              }
          }),
          ),
      ),
    );
  }
}