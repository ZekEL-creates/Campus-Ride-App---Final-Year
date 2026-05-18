import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';

class DriverOrRiderLoginNavigator extends StatelessWidget {
  final String role;
  final String roleInfo;
  final VoidCallback navigate;
  const DriverOrRiderLoginNavigator({
    super.key,
    required this.role,
    required this.roleInfo,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate();
      },
      splashColor: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.backgroundColor, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(roleInfo),
                ],
              ),

              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
