import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/dialogs/logout_dialog.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';
import 'package:ridesharingapp/services/Authentication/models/app_user.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  AppUser? rider;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInAsRider) {
          rider = state.rider;
        }
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Text("Hello ${rider!.name}, Would you like to log out?"),
                AppButton(
                  buttonName: "Logout",
                  onPressed: () async {
                    final shouldLogout = await showLogoutDialog(
                      context: context,
                    );
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(AuthEventLogOut());
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
