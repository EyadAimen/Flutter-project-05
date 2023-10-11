import 'package:flutter/material.dart';

// this file has everything that belong to the sign up and log in pages except for the firebase stuff 
//that will be located in the services folder

final emailInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(5),
  ),
  prefixIcon: const Icon(Icons.email),
  labelText: "Email",
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      style: BorderStyle.solid,
      width: 3,
      color: Colors.red,
    ),
  ),
);



final passwordInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(5),
  ),
  prefixIcon: const Icon(Icons.key),
  labelText: "Password",
  
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      style: BorderStyle.solid,
      width: 3,
      color: Colors.red,
    ),
  ),
);



final confirmPasswordInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      width: 3,
      
    ),
    borderRadius: BorderRadius.circular(5),
  ),
  prefixIcon: const Icon(Icons.key),
  labelText: "Confirm Password",
  
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      style: BorderStyle.solid,
      width: 3,
      color: Colors.red,
    ),
  ),
);



final userNamelInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      width: 3,
      
    ),
    borderRadius: BorderRadius.circular(5),
  ),
  prefixIcon: const Icon(Icons.person),
  labelText: "Username",

  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      width: 3,
      color: Colors.red,
    ),
    borderRadius: BorderRadius.circular(5),
  ),
);
