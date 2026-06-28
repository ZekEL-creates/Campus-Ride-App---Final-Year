import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? border;
  final Widget? child;
  final BorderSide? side;
  final Color? overlayColor;
  final double? horizontalPadding;
  final double? verticalPadding;

  const AppButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.child,
    this.side,
    this.overlayColor,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,

      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: side ?? BorderSide.none,
            borderRadius: BorderRadiusGeometry.circular(border ?? 20),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? AppColors.backgroundColor,
        ),

        foregroundColor: WidgetStatePropertyAll(
          foregroundColor ?? AppColors.lightBackgroundColor,
        ),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 100,
            vertical: verticalPadding ?? 20,
          ),
        ),
        overlayColor: WidgetStatePropertyAll(overlayColor),
      ),
      child: child ?? Text(buttonName),
    );
  }
}
