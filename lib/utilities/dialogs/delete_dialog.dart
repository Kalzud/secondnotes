import 'package:flutter/material.dart';
import 'package:secondnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    content: 'Are you sure you want to delete this note?',
    title: 'Delete',
    optionsBuilder: () => {
      'cancel': false,
      'delete': true,
    },
  ).then((value) => value ?? false);
}
