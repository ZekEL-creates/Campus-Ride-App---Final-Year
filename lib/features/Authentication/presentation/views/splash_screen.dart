import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/Authentication/presentation/views/driver_map_view.dart';
import 'package:ridesharingapp/features/Authentication/presentation/login_view.dart';
import 'package:ridesharingapp/features/map/presentation/map_view.dart';
import 'package:ridesharingapp/features/Authentication/presentation/registration%20screens/driver_register_view.dart';
import 'package:ridesharingapp/features/Authentication/presentation/registration%20screens/rider_register_view.dart';
import 'package:ridesharingapp/features/Authentication/presentation/registration%20screens/success_screen.dart';
import 'package:ridesharingapp/features/Authentication/presentation/views/select_role_register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthEventInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInAsRider) {
          return const MapView();
        } else if (state is AuthStateLoggedInAsDriver) {
          return const DriverMapView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRiderRegistering) {
          return const RegisterView();
        } else if (state is AuthStateDriverRegistering) {
          return const DriverRegisterView();
        } else if (state is AuthStateSelectRole) {
          return const SelectRoleToRegister();
        } else if (state is AuthStateRegistered) {
          return const SuccessScreen();
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
