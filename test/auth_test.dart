import 'package:secondnotes/services/auth/auth_exception.dart';
import 'package:secondnotes/services/auth/auth_provider.dart';
import 'package:secondnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialised at beginning', () {
      expect(provider.isInitialised, false);
    });

    test('Cannot logout if not initialised', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitialisedException>()));
    });

    test('Should be able to be initialised', () async {
      await provider.initialise();
      expect(provider.isInitialised, true);
    });

    test('The user should be null after initialisation', () async {
      expect(provider.currentUser, null);
    });

    test('Should initialise in less than 2 secocnds', () async {
      await Future.delayed(const Duration(seconds: 1));
      expect(provider.isInitialised, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login', () async {
      //test bad email user
      final badEmailUser = provider.createUser(
        email: 'bad-email',
        password: 'pass',
      );
      //through exception when this happens
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      //test bad password user
      final badPassUser = provider.createUser(
        email: 'email',
        password: 'wrong-pass',
      );
      //through exception when this happens
      expect(badPassUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      //now we test the positive and right scenario
      final user = await provider.createUser(
        email: 'email',
        password: 'password',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to login and logout', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      expect(provider.currentUser, isNotNull);
    });
  });
}

class NotInitialisedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _initialised = false;
  bool get isInitialised => _initialised;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _initialised = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialised) throw NotInitialisedException();
    if (email == 'bad-email') throw UserNotFoundAuthException();
    if (password == 'wrong-pass') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialised) throw NotInitialisedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user == null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitialisedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
