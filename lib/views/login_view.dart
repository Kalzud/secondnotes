import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/utilities/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter Password here'),
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    if (context.mounted) {
                      await showErrorDialog(context, 'User not found Please');
                    }
                  } else if (e.code == 'wrong-password') {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Wrong credentials');
                    }
                  } else {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    await showErrorDialog(context, e.toString());
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
