import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/routes/routes.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/firebase_auth_provider.dart';
import 'package:ridesharingapp/views/login_view.dart';
import 'package:ridesharingapp/views/map_view.dart';
import 'package:ridesharingapp/views/registration%20screens/rider_register_view.dart';
import 'package:ridesharingapp/views/select_role_register_screen.dart';
import 'package:ridesharingapp/views/splash_screen.dart';

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
      routes: {
        selectRole: (context) => SelectRoleToRegister(),
        map: (context) => MapView(),
        login: (context) => LoginView(),
        riderLogin: (context) => RegisterView(),
      },
    ),
  );
}
