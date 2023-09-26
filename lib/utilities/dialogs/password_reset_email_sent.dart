import 'package:flutter/material.dart';
import 'package:secondnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content:
        'We have sent you a password reset link please check your email for it',
    title: 'Password Reset',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
