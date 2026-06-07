import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/widgets/auth_view_card.dart';
import 'package:ridesharingapp/core/widgets/driver_or_rider_register_navigator.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectRoleToRegister extends StatelessWidget {
  const SelectRoleToRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AuthViewCard(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "A Driver Or Rider?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DriverOrRiderLoginNavigator(
              role: "Driver",
              roleInfo: "Tap here to register as a Driver",
              navigate: () {
                context.read<AuthBloc>().add(AuthEventSelectDriverRole());
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DriverOrRiderLoginNavigator(
              role: "Rider",
              roleInfo: "Tap here to register In as a Rider",
              navigate: () {
                context.read<AuthBloc>().add(AuthEventSelectRiderRole());
              },
            ),
          ),
        ],
      ),
    );
  }
}
