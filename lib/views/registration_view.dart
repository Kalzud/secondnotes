import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secondnotes/firebase_options.dart';

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
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'Enter email here'),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Enter Password here'),
                    ),
                    TextButton(
                        onPressed: () async {
                          try {
                            final email = _email.text;
                            final password = _password.text;
                            final usercredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            print(usercredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-email') {
                              print('Email is invalid');
                            } else if (e.code == 'email-already-in-use') {
                              print('email taken');
                            } else if (e.code == 'weak-password') {
                              print('weak password');
                            }
                          }
                        },
                        child: const Text('Register'))
                  ],
                );
              default:
                return const Text('Loading......');
            }
          },
        ));
  }
}
