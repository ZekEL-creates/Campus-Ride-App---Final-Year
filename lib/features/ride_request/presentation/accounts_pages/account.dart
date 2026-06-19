import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/logout_dialog.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/profile_list.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late final AppUser rider;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthBloc>().state;
    if (authUser is AuthStateLoggedInAsRider) {
      rider = authUser.rider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 234, 234, 234),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.lightBackgroundColor,
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            rider.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.lightDarktextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Role:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightDarktextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    13,
                                    116,
                                    17,
                                  ).withAlpha(30),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      13,
                                      116,
                                      17,
                                    ),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 13,
                                      color: const Color.fromARGB(
                                        255,
                                        13,
                                        116,
                                        17,
                                      ),
                                    ),
                                    Text(
                                      rider.role,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: const Color.fromARGB(
                                          255,
                                          13,
                                          116,
                                          17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 234, 234, 234),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ProfileList(
                            propertyName: 'Name',
                            property: 'Name:',
                            value: rider.name,
                            rider: rider,
                          ),

                          Divider(height: 40),

                          ProfileList(
                            propertyName: 'Email',
                            property: 'Email:',
                            value: rider.email,
                            rider: rider,
                          ),
                          Divider(height: 40),

                          ProfileList(
                            propertyName: 'Phone Number',
                            property: 'Phone Number:',
                            value: '09054508980',
                            rider: rider,
                          ),
                          Divider(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Designation:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightDarktextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                'Student',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightDarktextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Center(
                    child: AppButton(
                      onPressed: () async {
                        final shouldLogout = await showLogoutDialog(
                          context: context,
                        );
                        if (shouldLogout) {
                          context.read<AuthBloc>().add(AuthEventLogOut());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      side: BorderSide(color: AppColors.redColor),
                      buttonName: 'Logout',
                      backgroundColor: Colors.red.withAlpha(33),
                      foregroundColor: AppColors.redColor,
                      overlayColor: AppColors.redColor.withAlpha(70),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 10),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
