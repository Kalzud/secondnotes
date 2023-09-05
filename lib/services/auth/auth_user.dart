import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

//we want to limit how much of the firebase
//is seen so we want to get only the user
@immutable
class AuthUser {
  //creaing boolean varibale that would return true or false
  final bool isEmailVerified;
  // initialise the variable in constructor
  const AuthUser(this.isEmailVerified);

  //This factory is a constructor used to create instances of objcets and
  //in this case it is creating an instance of the objcet Auth user.
  //This Auth user is from firebase so it creates the AuthUser based on
  //User object from the firebase authentication this User object then grabs the
  //specified field argumnet of emailVerified from the firebase user
  //so basically creating an AuthUser object with the emailVerified from
  //User as an argument.
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
