import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

class AuthViewCard extends StatelessWidget {
  const AuthViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          "Campus Ride App",
          style: TextStyle(
            color: AppColors.lightBackgroundColor,
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
