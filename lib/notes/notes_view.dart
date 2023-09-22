import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondnotes/constants/routes.dart';
import 'package:secondnotes/enum/menu_action.dart';
import 'package:secondnotes/notes/notes_list_view.dart';
import 'package:secondnotes/services/auth/auth_service.dart';
import 'package:secondnotes/services/auth/bloc/auth_bloc.dart';
import 'package:secondnotes/services/auth/bloc/auth_event.dart';
import 'package:secondnotes/services/cloud/cloud.note.dart';
import 'package:secondnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:secondnotes/utilities/dialogs/logout_dialog.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          foregroundColor: const Color.fromARGB(246, 247, 245, 245),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
              color: const Color.fromARGB(246, 247, 245, 245),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      if (context.mounted) {
                        context.read<AuthBloc>().add(
                              const AuthEventLogout(),
                            );
                      }
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Logout')),
                ];
              },
              color: const Color.fromARGB(246, 247, 245, 245),
            )
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.getAllNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  //view to list out notes
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: ((note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    }),
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
