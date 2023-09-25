import 'package:secondnotes/services/auth/auth_provider.dart';
import 'package:secondnotes/services/auth/auth_user.dart';
import 'package:secondnotes/services/auth/firebase_auth_provider.dart';

//Here this class would get info from the provider which gets
//info from the databse its almost like this service class is
//the contoller and the provider is the model in and mvc.
//It is from this servide class we would now give info to the UI.
class AuthService implements AuthProvider {
  final AuthProvider provider;
  //constructor
  AuthService(this.provider);

  //factory to create an AuthService instance already
  //with the Provider argument of type irebaseAuthProvider
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialise() => provider.initialise();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);
}
