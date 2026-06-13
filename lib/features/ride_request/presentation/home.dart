import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/features/map/presentation/map_view.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_bloc.dart';
import 'package:ridesharingapp/features/ride_request/domain/bloc/ride_event.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapView(),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 10,
                ),
                child: AppButton(
                  buttonName: '',
                  onPressed: () {
                    context.read<RideBloc>().add(RideEventRideRequest());
                  },
                  border: 20,
                  backgroundColor: AppColors.lightBackgroundColor,
                  foregroundColor: AppColors.backgroundColor,
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.backgroundColor),
                      SizedBox(width: 5),
                      Text('Request Ride'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Request Ride',
//                     hintStyle: TextStyle(color: AppColors.backgroundColor),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: AppColors.backgroundColor,
//                     ),
//                     filled: true,
//                     fillColor: AppColors.lightBackgroundColor,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide(color: AppColors.backgroundColor),
//                     ),
//                   ),
//                 ),
