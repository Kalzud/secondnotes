import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondnotes/services/auth/bloc/auth_bloc.dart';
import 'package:secondnotes/services/auth/bloc/auth_event.dart';

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
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text('Send verification email')),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogout(),
                    );
              },
              child: const Text('Restart')),
        ]),
      ),
    );
  }
}
