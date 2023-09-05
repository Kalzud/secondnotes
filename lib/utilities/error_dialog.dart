// This contains the handler for the error messages
// it would take in a context and text varaible
// that text would be error shown to user and it would
// depend on the error code.

import 'package:flutter/material.dart';

// Future showing and telling dart that the value
// for this method is not yet avaiable but would
// be in the future.
Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  // [Personal note ignore comment]:
  // Dialog pop up box need show dialog
  // for scrolling of content and alert
  // to show the butons.
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An Error Occurred'),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  // Remove popup and back to screen
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      });
}
