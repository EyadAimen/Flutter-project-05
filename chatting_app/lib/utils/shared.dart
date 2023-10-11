import 'package:flutter/material.dart';


// this file is for the textStyles
const appBarStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 22,
  color: Colors.white
);


const nameStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
);


const subtitleStyle = TextStyle(
  fontWeight: FontWeight.w200,
  fontSize: 12,
);

const messagesStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 14,
);

const urlMessagesStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Colors.blue,
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue,
);



// this list and function for selecting a color for the Circle avatar

  List<Color?> avatarColors = [Colors.green[200],Colors.blue[200],Colors.red[200],Colors.orange[200],Colors.cyan[200],Colors.brown[200],];
  Color? colorSelector(String char){
    String smallChar = char.toLowerCase();
    if(smallChar.runes.first >= 97 && smallChar.runes.first < 102){
      return avatarColors[0];
    }
    else if(smallChar.runes.first >= 97 && smallChar.runes.first < 102){
      return avatarColors[1];
    }
    else if(smallChar.runes.first >= 102 && smallChar.runes.first < 107){
      return avatarColors[2];
    }
    else if(smallChar.runes.first >= 107 && smallChar.runes.first < 112){
      return avatarColors[3];
    }
    else if(smallChar.runes.first >= 112 && smallChar.runes.first < 117){
      return avatarColors[4];
    }
    else{
      return avatarColors[5];
    }
  }
