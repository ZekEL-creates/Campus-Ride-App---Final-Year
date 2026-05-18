import 'package:flutter/material.dart';

import 'package:ridesharingapp/core/routes/routes.dart';
import 'package:ridesharingapp/core/widgets/auth_view_card.dart';
import 'package:ridesharingapp/core/widgets/driver_or_rider_register_navigator.dart';

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
                Navigator.of(context).pushNamed(driverLogin);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DriverOrRiderLoginNavigator(
              role: "Rider",
              roleInfo: "Tap here to register In as a Rider",
              navigate: () {
                Navigator.of(context).pushNamed(riderLogin);
              },
            ),
          ),
        ],
      ),
    );
  }
}
