import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String buttonName;
  final Function() onPressed;

  const AppButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.backgroundColor),
        foregroundColor: WidgetStatePropertyAll(AppColors.lightBackgroundColor),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        ),
      ),
      child: Text(buttonName),
    );
  }
}
