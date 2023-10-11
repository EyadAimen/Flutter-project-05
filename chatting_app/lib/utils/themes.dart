import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// this class has the light and dark theme
class Themes{


  // for the light theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    
    // to be changed
    scaffoldBackgroundColor: const Color.fromARGB(255, 102, 60, 199),


    // to set the font family to all the text
    textTheme: GoogleFonts.rubikTextTheme(),


    // this color is  used for the body of the scaffold
    primaryColor: Colors.white,
    // this is for the text color it will be black when the theme is light and white when the theme is dark
    colorScheme: const ColorScheme.light(),
    

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      

      // to be changed
      backgroundColor: Color.fromARGB(255, 102, 60, 199),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedIconTheme: IconThemeData(color: Colors.grey),
  
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),

    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
    ),


    iconTheme: IconThemeData(color: Colors.deepPurple[300],size: 20,),


    // this is for the messages container
    primaryColorLight: Colors.deepPurple[200],
    primaryColorDark: Colors.grey[300],
  );
  
  
  

  // for the dark theme
  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 102, 60, 199),
    
    // to set the font family to all the text
    textTheme: GoogleFonts.rubikTextTheme(),
    
    // this color is  used for the body of the scaffold
    primaryColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      secondary: Colors.deepPurple[300]!
    ),


    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color.fromARGB(255, 102, 60, 199),
    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      
      backgroundColor: Colors.grey[900],
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      
        
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey[900],
    ),

    dialogBackgroundColor: Colors.red,
    dialogTheme: const DialogTheme(
      backgroundColor:  Color.fromARGB(255, 33, 33, 33),
    ),

    iconTheme: IconThemeData(color: Colors.deepPurple[300],size: 20,),


    // this is for the messages container
    primaryColorLight: Colors.deepPurple[700],
    primaryColorDark: Colors.grey[700],

    
  );
}