import 'package:flutter/widgets.dart';
import 'package:ridesharingapp/core/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    title: "Logging Out",
    content: "Do you really want to Logout?",
    optionsBuilder: () => {'Cancel': false, 'Ok': true},
  ).then((value) => value ?? false);
}
