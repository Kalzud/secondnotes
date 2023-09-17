class CloudStorageException implements Exception {
  const CloudStorageException();
}

// c = create
// r = retrieve
// u = update
// d = delete

//c in crud
class CouldNotCreateNoteException implements CloudStorageException {}

//r in crud
class CouldNotGetAllNotesException implements CloudStorageException {}

//u in crud
class CouldNotUpdateNoteException implements CloudStorageException {}

//d in crud
class CouldNotDeleteNoteException implements CloudStorageException {}
