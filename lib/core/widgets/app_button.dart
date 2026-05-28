import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String buttonName;
  final Function() onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? AppColors.backgroundColor,
        ),
        foregroundColor: WidgetStatePropertyAll(
          foregroundColor ?? AppColors.lightBackgroundColor,
        ),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        ),
      ),
      child: Text(buttonName),
    );
  }
}
