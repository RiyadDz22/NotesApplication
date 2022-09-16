import 'package:flutter/cupertino.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'are you sure you want to logout?',
    optionsBuilder: () => {
      'Cancel': false,
      'log out': true,
    },
  ).then((value) => value ?? false);
}
