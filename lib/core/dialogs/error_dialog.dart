import 'package:flutter/widgets.dart';
import 'package:ridesharingapp/core/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required String content,
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: "An Error Occured",
    content: content,
    optionsBuilder: () => {'Ok': null},
  );
}
