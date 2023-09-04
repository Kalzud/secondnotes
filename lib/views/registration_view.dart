import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/utilities/error_dialog.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
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
        title: const Text('Register'),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(verifyRoute);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-email') {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Invalid email');
                    }
                  } else if (e.code == 'email-already-in-use') {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Email already taken');
                    }
                  } else if (e.code == 'weak-password') {
                    if (context.mounted) {
                      await showErrorDialog(
                          context, 'Weak password at least 6 characters');
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
