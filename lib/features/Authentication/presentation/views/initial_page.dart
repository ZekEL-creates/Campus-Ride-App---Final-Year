import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/error_dialog.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/map/data/map_exceptions.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateInitializing) {
            if (state.exception is LocationServiceDisabledException) {
              showErrorDialog(
                content: 'Please turn on Location',
                context: context,
              );
            }
            if (state is LocationPermissionDeniedException) {
              showErrorDialog(
                content: 'Location Permission is not granted',
                context: context,
              );
            }
            if (state is CouldNotGetDataException) {
              showErrorDialog(content: 'An error occured', context: context);
            }
          }
        },
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
      ),
    );
  }
}
