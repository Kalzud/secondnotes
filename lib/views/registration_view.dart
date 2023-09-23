import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondnotes/services/auth/auth_exception.dart';
import 'package:secondnotes/services/auth/bloc/auth_bloc.dart';
import 'package:secondnotes/services/auth/bloc/auth_event.dart';
import 'package:secondnotes/services/auth/bloc/auth_state.dart';
import 'package:secondnotes/utilities/dialogs/error_dialog.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  //initialise the controllers
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //dispose of controller data after so it can be refilled
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold is the contxt or canvas the user sees
    //on screen without it would be a blank black screen
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, 'Weak password at least 6 characters');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already taken');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed Registration');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          foregroundColor: const Color.fromARGB(246, 247, 245, 245),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter email here'),
            ),
            TextField(
              controller: _password,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: 'Enter Password here'),
            ),
            TextButton(
                onPressed: () {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Register')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogout(),
                      );
                },
                child: const Text('Aready have an account? Login here')),
          ],
        ),
      ),
    );
  }
}
