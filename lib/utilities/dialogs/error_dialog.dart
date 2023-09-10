import 'package:flutter/material.dart';
import 'package:secondnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    content: text,
    title: 'An Error Ocurred',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
