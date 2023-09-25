import 'package:secondnotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialise();
  //check if there is and auth user and then get it
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
