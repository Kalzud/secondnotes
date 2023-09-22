import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/services/auth/auth_exception.dart';
import 'package:secondnotes/services/auth/bloc/auth_bloc.dart';
import 'package:secondnotes/services/auth/bloc/auth_event.dart';
import 'package:secondnotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            decoration: const InputDecoration(hintText: 'Enter Password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  context.read<AuthBloc>().add(
                        AuthEventLogin(
                          email,
                          password,
                        ),
                      );
                } on UserNotFoundAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'User not found');
                  }
                } on WrongPasswordAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Wrong credentials');
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Authentication Error');
                  }
                }
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Do not have an account? Register here')),
        ],
      ),
    );
  }
}
