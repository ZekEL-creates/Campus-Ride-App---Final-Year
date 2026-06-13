import 'package:flutter/material.dart';

class Ride extends StatefulWidget {
  const Ride({super.key});

  @override
  State<Ride> createState() => _RideState();
}

class _RideState extends State<Ride> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Ride View")));
  }
}
