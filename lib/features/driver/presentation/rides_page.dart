import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/enum/status.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/error_view.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';
import 'package:ridesharingapp/features/driver/domain/driver_bloc.dart';
import 'package:ridesharingapp/features/driver/domain/driver_event.dart';
import 'package:ridesharingapp/features/driver/domain/driver_state.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({super.key});

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  AppUser? driver;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthStateLoggedInAsDriver) {
      driver = authState.driver;
    }
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(
      builder: (context, state) {
        final driverState = state as DriverStateDriver;
        final rides = driverState.rides;
        final List<RideModel> availableRides;
        if (rides == null) {
          availableRides = [];
        } else {
          availableRides = rides.where((ride) {
            final notRejected =
                ride.rejectedDrivers == null ||
                !ride.rejectedDrivers!.contains(driver!.id);
            final isPending =
                ride.status == Status.Requested.name; // only show pending
            return notRejected && isPending;
          }).toList();
        }

        if (driverState.isLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (driverState.error != null) {
          return Scaffold(
            body: ErrorView(
              message: 'Could not load ride requests. Please try again.',
              onRetry: () {
                context.read<DriverBloc>().add(
                  const DriverEventListenForRides(),
                );
              },
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TabBar(
                    indicator: BoxDecoration(color: AppColors.backgroundColor),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    labelPadding: EdgeInsets.all(10),
                    controller: _tabController,
                    tabs: [
                      Text('Requested'),
                      Text('Active Ride'),
                      Text('Completed'),
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.lightBackgroundColor,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Builder(
                          builder: (_) {
                            if (!driverState.isOnline) {
                              return Center(
                                child: Column(
                                  mainAxisSize: .min,
                                  children: [
                                    Icon(Icons.schedule, size: 100),
                                    SizedBox(height: 20),
                                    Text('You are currently Offline'),
                                  ],
                                ),
                              );
                            }
                            if (availableRides.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: .min,
                                  children: [
                                    Icon(Icons.schedule, size: 100),
                                    SizedBox(height: 20),
                                    Text('Awaiting Ride Request'),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: availableRides.length,
                              itemBuilder: (context, index) {
                                final ride = availableRides[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                        255,
                                        35,
                                        35,
                                        35,
                                      ),
                                      // gradient: LinearGradient(
                                      //   colors: [
                                      //     AppColors.backgroundColor,
                                      //     const Color.fromARGB(
                                      //       255,
                                      //       10,
                                      //       13,
                                      //       193,
                                      //     ),
                                      //   ],
                                      //   begin: Alignment.bottomLeft,
                                      //   end: Alignment.topRight,
                                      // ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: Text(
                                            'From: ${ride.pickUpName}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: AppColors
                                                  .lightBackgroundColor,
                                              fontWeight: .w700,
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: Text(
                                            'Going to: ${ride.destinationName}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: AppColors
                                                  .lightBackgroundColor,
                                              fontWeight: .w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                        Row(
                                          mainAxisAlignment: .center,
                                          children: [
                                            AppButton(
                                              side: BorderSide(
                                                color: AppColors.greenColor,
                                              ),
                                              buttonName: 'Accept',
                                              horizontalPadding: 50,
                                              onPressed: () {
                                                context.read<DriverBloc>().add(
                                                  DriverEventAcceptRide(
                                                    rideId: ride.id,
                                                    driver: driver!,
                                                  ),
                                                );
                                                context.read<DriverBloc>().add(
                                                  DriverEventTrackRide(ride),
                                                );
                                              },
                                              backgroundColor: AppColors
                                                  .lightBackgroundColor,
                                              foregroundColor:
                                                  AppColors.greenColor,
                                            ),
                                            SizedBox(width: 15),
                                            AppButton(
                                              side: BorderSide(
                                                color: AppColors.redColor,
                                              ),
                                              buttonName: 'Decline',
                                              horizontalPadding: 50,
                                              onPressed: () {
                                                context.read<DriverBloc>().add(
                                                  DriverEventRejectRide(
                                                    rideId: ride.id,
                                                    driver: driver!,
                                                  ),
                                                );
                                              },
                                              backgroundColor: AppColors
                                                  .lightBackgroundColor,
                                              foregroundColor:
                                                  AppColors.redColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        Center(child: Text('Active ride')),

                        // Builder(
                        //   builder: (_) {
                        //     final acceptedRideByDriver = availableRides.where((
                        //       ride,
                        //     ) {
                        //       return ride.status == 'accepted' &&
                        //           ride.driverId == driver!.id;
                        //     }).toList();
                        //     if (acceptedRideByDriver.isEmpty) {
                        //       return Center(
                        //         child: Column(
                        //           mainAxisSize: .min,
                        //           children: [
                        //             Icon(Icons.schedule, size: 100),
                        //             SizedBox(height: 20),
                        //             Text('You have no active rides'),
                        //           ],
                        //         ),
                        //       );
                        //     }

                        //     return ListView.builder(
                        //       itemCount: availableRides.length,
                        //       itemBuilder: (context, index) {
                        //         final ride = availableRides[index];

                        //         return Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //             vertical: 4.0,
                        //           ),
                        //           child: Container(
                        //             padding: EdgeInsets.symmetric(
                        //               horizontal: 8,
                        //               vertical: 20,
                        //             ),
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(10),
                        //               color: const Color.fromARGB(
                        //                 255,
                        //                 35,
                        //                 35,
                        //                 35,
                        //               ),
                        //             ),
                        //             child: Column(
                        //               crossAxisAlignment: .start,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                     horizontal: 16.0,
                        //                   ),
                        //                   child: Text(
                        //                     'From: ${ride.pickUpName}',
                        //                     style: TextStyle(
                        //                       fontSize: 20,
                        //                       color: AppColors
                        //                           .lightBackgroundColor,
                        //                       fontWeight: .w700,
                        //                     ),
                        //                   ),
                        //                 ),

                        //                 Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                     horizontal: 16.0,
                        //                   ),
                        //                   child: Text(
                        //                     'Going to: ${ride.destinationName}',
                        //                     style: TextStyle(
                        //                       fontSize: 20,
                        //                       color: AppColors
                        //                           .lightBackgroundColor,
                        //                       fontWeight: .w700,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(height: 40),
                        //                 Center(
                        //                   child: AppButton(
                        //                     side: BorderSide(
                        //                       color: AppColors.backgroundColor,
                        //                     ),
                        //                     buttonName: 'Back To Tracking Page',
                        //                     horizontalPadding: 50,
                        //                     onPressed: () {
                        //                       context.read<DriverBloc>().add(
                        //                         DriverEventResumeTracking(),
                        //                       );
                        //                     },
                        //                     backgroundColor:
                        //                         AppColors.lightBackgroundColor,
                        //                     foregroundColor:
                        //                         AppColors.greenColor,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),
                        Center(child: Text('Completed Rides')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
