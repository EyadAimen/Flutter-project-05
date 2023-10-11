import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


// the firestore will be of one main collection which is users
// the users collection contains documents of all app users who signed up
// each user document will have the same id of the firebase auth
// inside each user document will have the user`s userName and a collection of messagesList
// the messagesList collection contains documents that have the ids of the user`s id of the added user
// the messagesList will be displayed on the home screen and its where the users will interact with each other
// each messagesList document contains a collection of messages
// the messages collection will have the all messages sent between the 2 users
// each document will have the message field, date field, and the from field
// the from field will contain the id of the user that sent the message so it will be displayed differently for different users










// this class is for the signing up that takes the parameters
class DatabaseService{

  // this constructor will have the user id from the auth service
  // will also take the first name and the last naame from the textFied
  DatabaseService({required this.uid,required this.userName});
  final String uid;
  final String userName;

  // collection Refrence
  // this collection will contain all users
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  


  // this function will set the users data in the firebase when signing up
  Future setUsersData() async{
    final token = await FirebaseMessaging.instance.getToken().then((value) => value.toString());
    // every user document will have these data 
    // username of the user
    // tpken of the users logged in /sgned up device
    // notification indicator for sending a notification
    return await usersCollection.doc(uid).set({
      "userName": userName,
      "token": token,
      "notificationStatus": false,
      "pic": ""
    });
  }
}



// this class is for the database functions that the users call from the app
class DatabaseAppFunctions{
 // collection Refrence
  // this collection will contain all users
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  // this is the current user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // this is for the messagesList collection of the current user
  late final CollectionReference messagesListCollection = usersCollection.doc(currentUser!.uid).collection("messagesList");

  // to update the token when the user signs in
  final userToken = FirebaseMessaging.instance;
  updateToken() async{
    final token = await userToken.getToken().then((value) => value.toString());
    usersCollection.doc(currentUser!.uid).update({
      "token" : token,
    });
  }
}