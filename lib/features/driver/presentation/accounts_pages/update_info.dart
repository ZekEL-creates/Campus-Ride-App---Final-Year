import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_bloc.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({
    super.key,
    required this.propertyToUpdate,
    required this.rider,
  });
  final String propertyToUpdate;
  final AppUser rider;

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              // if (state is AuthStateLoggedInAsRider) {
              //   await showSuccessDialog(
              //     context: context,
              //     content: 'Updated Successfully',
              //   );
              Navigator.pop(context);
              // }
            },
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardColor,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back, size: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Update ${widget.propertyToUpdate}',
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Update ${widget.propertyToUpdate}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.backgroundColor),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: AppButton(
                    buttonName: 'Update',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthEventUpdateInfo(
                          id: widget.rider.id,
                          data: {
                            widget.propertyToUpdate.toLowerCase():
                                textController.text,
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
