import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ridesharingapp/core/constants/colors.dart';

import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/driver/domain/driver_bloc.dart';
import 'package:ridesharingapp/features/driver/domain/driver_event.dart';
import 'package:ridesharingapp/features/driver/domain/driver_state.dart';

import 'package:ridesharingapp/features/map/presentation/map_view.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  AppUser? driver;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthStateLoggedInAsDriver) {
      driver = authState.driver;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(
      builder: (context, state) {
        final driverState = state as DriverStateDriver;
        if (driverState.error != null) {
          return Scaffold(
            body: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.signal_wifi_0_bar_sharp,
                  size: 30,
                  color: AppColors.lightDarktextColor,
                ),
                SizedBox(height: 20),
                Text('An Error has occured. Please try again'),
                AppButton(
                  buttonName: 'Retry',
                  onPressed: () {
                    driverState.isLoading
                        ? null
                        : () async {
                            if (driverState.isOnline) {
                              context.read<DriverBloc>().add(
                                DriverEventGoOffline(driver!),
                              );
                            } else {
                              context.read<DriverBloc>().add(
                                DriverEventGoOnline(driver: driver!),
                              );
                            }
                          };
                  },
                ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              MapView(),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 10,
                  ),
                  child: AppButton(
                    buttonName: '',
                    onPressed: driverState.isLoading
                        ? null
                        : () {
                            if (driverState.isOnline) {
                              context.read<DriverBloc>().add(
                                DriverEventGoOffline(driver!),
                              );
                            } else {
                              context.read<DriverBloc>().add(
                                DriverEventGoOnline(driver: driver!),
                              );
                            }
                          },

                    border: 20,
                    side: BorderSide(
                      width: 2,
                      color: driverState.isOnline
                          ? AppColors.greenColor
                          : AppColors.redColor,
                    ),
                    backgroundColor: AppColors.lightBackgroundColor,
                    foregroundColor: driverState.isOnline
                        ? AppColors.greenColor
                        : AppColors.redColor,
                    child: driverState.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(
                              color: Color.fromARGB(255, 131, 131, 131),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: driverState.isOnline
                                    ? AppColors.greenColor
                                    : AppColors.redColor,
                                size: 13,
                              ),
                              SizedBox(width: 10),
                              Text(
                                driverState.isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  fontWeight: .w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
