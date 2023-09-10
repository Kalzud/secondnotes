import 'package:flutter/material.dart';
import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/services/auth/auth_exception.dart';
import 'package:secondnotes/services/auth/auth_service.dart';
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
    return Scaffold(
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
            decoration: const InputDecoration(hintText: 'Enter Password here'),
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await AuthService.firebase()
                      .createUser(email: email, password: password);
                  AuthService.firebase().sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(verifyRoute);
                  }
                } on InvalidEmailAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Invalid email');
                  }
                } on EmailAlreadyInUseAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Email already taken');
                  }
                } on WeakPasswordAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                        context, 'Weak password at least 6 characters');
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Failed Registration');
                  }
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Aready have an account? Login here')),
        ],
      ),
    );
  }
}
