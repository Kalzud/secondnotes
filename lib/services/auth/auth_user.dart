import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

//we want to limit how much of the firebase
//is seen so we want to get only the user
@immutable
class AuthUser {
  //creaing boolean varibale that would return true or false
  final bool isEmailVerified;
  // initialise the variable
  const AuthUser(this.isEmailVerified);

  //
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
