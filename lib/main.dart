import 'package:flutter/material.dart';
import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/notes/new_note_view.dart';
import 'package:secondnotes/services/auth/auth_service.dart';
import 'package:secondnotes/views/login_view.dart';
import 'package:secondnotes/notes/notes_view.dart';
import 'package:secondnotes/views/registration_view.dart';
import 'package:secondnotes/views/verify_email_view.dart';

//main method , the async in front of the bracket
//means it follows the function inside the method line
//by line not simuteanously
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Second Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegistrationView(),
        notesRoute: (context) => const NoteView(),
        verifyRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialise(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
