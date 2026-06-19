import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/generic_dialog.dart';

Future<void> showSuccessDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog(
    icon: Icon(Icons.check, color: AppColors.greenColor, size: 20),
    context: context,
    title: 'Completed Successfully',
    content: content,
    optionsBuilder: () => {'OK': null},
  );
}
