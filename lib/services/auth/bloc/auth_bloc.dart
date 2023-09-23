import 'package:bloc/bloc.dart';
import 'package:secondnotes/services/auth/auth_provider.dart';
import 'package:secondnotes/services/auth/bloc/auth_event.dart';
import 'package:secondnotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialised()) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    //register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(null));
    });

    //initialise
    on<AuthEventInitialise>((event, emit) async {
      await provider.initialise();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null, false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    //Login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(null, true));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(null, false));
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(null, false));
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e, false));
      }
    });

    //logout
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null, false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e, false));
      }
    });
  }
}
