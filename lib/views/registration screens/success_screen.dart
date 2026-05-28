import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/json/Confetti.json',
                height: 300,
                repeat: false,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 15),
              Text(
                "Successfully Registered",
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.lightBackgroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Click Button below to continue.",
                style: TextStyle(color: AppColors.lightBackgroundColor),
              ),
              Expanded(child: SizedBox()),
              AppButton(
                buttonName: 'Continue',
                backgroundColor: AppColors.lightBackgroundColor,
                foregroundColor: AppColors.backgroundColor,
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventInitialize());
                },
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
