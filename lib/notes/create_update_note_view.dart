import 'package:flutter/material.dart';
import 'package:secondnotes/services/auth/auth_service.dart';
import 'package:secondnotes/services/cloud/cloud.note.dart';
import 'package:secondnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:secondnotes/utilities/dialogs/cannot_send_empty_note_dialog.dart';
import 'package:secondnotes/utilities/generics/get_argument.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNotes(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      await _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        foregroundColor: const Color.fromARGB(246, 247, 245, 245),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              if (_note == null || text.isEmpty) {
                await showCannotSendEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start Typing note in here.......',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
