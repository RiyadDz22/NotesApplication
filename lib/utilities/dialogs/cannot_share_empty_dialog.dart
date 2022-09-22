import 'package:flutter/cupertino.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'sharing',
      content: 'you cannot share an empty note',
      optionsBuilder: () => {
        'Ok': null,
      });
}