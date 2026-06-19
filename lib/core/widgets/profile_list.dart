import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/constants/constants.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/ride_request/presentation/accounts_pages/update_info.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({
    super.key,
    required this.propertyName,
    required this.property,
    required this.value,
    required this.rider,
  });
  final String propertyName;
  final String property;
  final String value;
  final AppUser rider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updatePropertyName = propertyName;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<AuthBloc>(),
              child: UpdateInfo(propertyToUpdate: propertyName, rider: rider),
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            property,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.lightDarktextColor,
            ),
          ),

          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightDarktextColor,
                ),
              ),
              SizedBox(width: 7),
              Icon(Icons.arrow_forward_ios, size: 13),
            ],
          ),
        ],
      ),
    );
  }
}
