import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

typedef DialogOptionsBuilder<T> = Map<String, dynamic> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionsBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.lightDarktextColor,
        title: Text(
          title,
          style: TextStyle(color: AppColors.lightBackgroundColor),
        ),
        content: Text(
          content,
          style: TextStyle(color: AppColors.lightBackgroundColor),
        ),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                AppColors.lightBackgroundColor,
              ),
            ),
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
