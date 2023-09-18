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
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                )),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> getAllNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));
}
