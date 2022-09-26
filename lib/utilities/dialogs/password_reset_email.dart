import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(context: context,
      title: 'Password Reset',
      content: 'We have sent you now a password reset email',
      optionsBuilder: () => {
    'Ok': null
      }
  );
}