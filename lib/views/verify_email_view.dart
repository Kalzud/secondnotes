import 'package:flutter/material.dart';
import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        foregroundColor: const Color.fromARGB(246, 247, 245, 245),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(children: [
          const Text('Please check your email and verify'),
          const Text('If you did not see email click below'),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send verification email')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text('Restart')),
        ]),
      ),
    );
  }
}
