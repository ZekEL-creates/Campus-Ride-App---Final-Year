import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/features/driver/data/driver_repository.dart';
import 'package:ridesharingapp/features/driver/domain/driver_bloc.dart';
import 'package:ridesharingapp/features/driver/domain/driver_event.dart';
import 'package:ridesharingapp/features/driver/domain/driver_state.dart';
import 'package:ridesharingapp/features/driver/presentation/accounts_pages/account_page.dart';
import 'package:ridesharingapp/features/driver/presentation/driver_home.dart';
import 'package:ridesharingapp/features/driver/presentation/ride_tracking_page.dart';
import 'package:ridesharingapp/features/driver/presentation/rides_page.dart';
import 'package:ridesharingapp/features/map/data/map_repository.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DriverBloc>(
      create: (context) => DriverBloc(DriverRepository(), MapRepository()),
      child: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          final driverState = state as DriverStateDriver;
          if (driverState.isViewingTracking) {
            return RideTrackingPage(
              onBack: () {
                context.read<DriverBloc>().add(DriverEventCloseTracking());
              },
            );
          }
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [DriverHome(), RidesPage(), AccountPage()],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: AppColors.backgroundColor,
              onTap: (index) {
                _selectedIndex = index;
                setState(() {});
              },
              selectedItemColor: AppColors.lightDarktextColor,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: 'Rides',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Account',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
