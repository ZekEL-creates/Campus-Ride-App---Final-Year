import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final IconData? icon;

  const ErrorView({
    super.key,
    this.message = 'Something went wrong. Please try again.',
    this.retryLabel = 'Retry',
    required this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.wifi_off_rounded,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            AppButton(
              buttonName: retryLabel,
              onPressed: onRetry,
              backgroundColor: AppColors.backgroundColor,
              //Theme.of(context).primaryColor
              foregroundColor: Colors.white,
              border: 12,
            ),
          ],
        ),
      ),
    );
  }
}
