import 'package:flutter/material.dart';
import 'package:secondnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    content: 'Are you sure you want to log out?',
    title: 'Logging Out?',
    optionsBuilder: () => {
      'cancel': false,
      'logout': true,
    },
  ).then((value) => value ?? false);
}
