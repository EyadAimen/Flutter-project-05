import 'package:chatting_app/services/firebase/auth.dart';
import 'package:chatting_app/utils/themes.dart';
import 'package:chatting_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // for web
  if(kIsWeb){
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCW6rdlV6zzYWe2YkajEq1sLRR_pHQiR0U", appId: "1:749749480313:web:605fb1cdb0823ab2dedda8", messagingSenderId: "749749480313", projectId: "chatting-app-808e9"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      // here determining what stream we are listening
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chatting app",
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: ThemeMode.system,
        home: const Wrapper(),
      ),
    );
  }
}