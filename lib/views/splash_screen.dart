import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';
import 'package:ridesharingapp/views/login_view.dart';
import 'package:ridesharingapp/views/map_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return MapView();
        } else if (state is AuthStateLoggedOut) {
          return LoginView();
        } else {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
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
      },
    );
  }
}
