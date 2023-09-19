import 'package:flutter/material.dart';
import 'package:secondnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotSendEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: 'Cannot share empty notes please!',
    title: 'Sharing',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
