import 'package:chatting_app/services/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


// there is a difference in the syntax
// the FireBaseUser is now called User

class AuthService{

  // this gives us access to all the functions in the firebase auth (sing in sign uo etc)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change stream
  Stream<User?> get user{
    return _auth.authStateChanges();
  }
  // register with email and password functions
  Future signUpWithEmailANDPassword(String email, String password,String userName) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      String uid = user!.uid;
      // here the user will be added to the users collection
      await DatabaseService(uid: uid,userName: userName,).setUsersData();
      return user;
    }catch(e){
      return null;
    }
  }


  // sign in with email and password functions
  Future signInWithEmailANDPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      DatabaseAppFunctions().updateToken();
      return user;
    }catch(e){
      return null;
    }
  }



  // sign out functions
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      return null;
    }
  }
}
