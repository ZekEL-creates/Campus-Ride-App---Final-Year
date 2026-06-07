import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/auth_service/firebase_auth_provider.dart';
import 'package:ridesharingapp/features/Authentication/presentation/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBackgroundColor,
        fontFamily: "HostGrotesk",
        textTheme: TextTheme(),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: SplashScreen(),
      ),
    ),
  );
}
