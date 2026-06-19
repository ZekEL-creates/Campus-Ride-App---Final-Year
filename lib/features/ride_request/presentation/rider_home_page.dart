import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_repository.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_bloc.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_state.dart';
import 'package:ridesharingapp/features/ride_request/presentation/accounts_pages/account.dart';
import 'package:ridesharingapp/features/ride_request/presentation/home.dart';
import 'package:ridesharingapp/features/ride_request/presentation/request_ride.dart';
import 'package:ridesharingapp/features/ride_request/presentation/ride.dart';
import 'package:ridesharingapp/features/ride_request/presentation/ride_searching_view.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideBloc(RideRepository()),
      child: Scaffold(
        body: BlocListener<RideBloc, RideState>(
          listener: (context, state) {
            if (state is RideStateRequested) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RideSearchingView(
                    ride: state.ride,
                    routePoints: state.route,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<RideBloc, RideState>(
            builder: (context, state) {
              if (state is RideStateLoading) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state is RideStateSelectLocation) {
                return RequestRide(state: state);
              } else if (state is RideStateError) {
                return Center(child: Text(state.exception.toString()));
              }
              return Scaffold(
                body: IndexedStack(
                  index: _selectedIndex,
                  children: [Home(), Ride(), Account()],
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
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
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
        ),
      ),
    );
  }
}
