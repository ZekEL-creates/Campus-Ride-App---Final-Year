import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';

class DriverMapView extends StatefulWidget {
  const DriverMapView({super.key});

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppButton(
          buttonName: 'Logout',
          onPressed: () {
            context.read<AuthBloc>().add(AuthEventLogOut());
          },
        ),
      ),
    );
  }
}
