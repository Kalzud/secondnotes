import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondnotes/services/cloud/cloud.note.dart';
import 'package:secondnotes/services/cloud/cloud_storage.dart';
import 'package:secondnotes/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  // create and get an instance of this so there is only one instance
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  void createNotes({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get();
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
