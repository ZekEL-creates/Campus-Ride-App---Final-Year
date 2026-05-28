import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/error_dialog.dart';
import 'package:ridesharingapp/core/dialogs/loading_dialog.dart';
import 'package:ridesharingapp/core/enum/user_role.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/auth_view_card.dart';
import 'package:ridesharingapp/core/widgets/text_field.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_exceptions.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';

class DriverRegisterView extends StatefulWidget {
  const DriverRegisterView({super.key});

  @override
  State<DriverRegisterView> createState() => _DriverRegisterViewState();
}

class _DriverRegisterViewState extends State<DriverRegisterView> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  CloseDialog? _closeDialog;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateDriverRegistering) {
          final closeDialog = _closeDialog;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialog = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialog = showLoadingDialog(
              context: context,
              text: "Registering",
            );
          }

          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              content: "You have entered an invalid email",
              context: context,
            );
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              content: "Password should be 8 characters long",
              context: context,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              content: "Email already exists",
              context: context,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              content: "Unable to Register. Please Try Again",
              context: context,
            );
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthViewCard(),
              SizedBox(height: 20),
              Text(
                "Register As A Driver",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4B4B4B),
                ),
              ),
              SizedBox(height: 10),
              AppTextField(
                controller: nameController,
                topHint: "Enter Your Name",
                hintText: "Enter Name",
                icon: Icons.person_outline,
              ),
              SizedBox(height: 10),
              AppTextField(
                controller: emailController,
                topHint: "Enter Your Email",
                hintText: "Email",
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 10),
              AppTextField(
                controller: passwordController,
                topHint: "Enter Your Password",
                obscureText: true,
                hintText: "********",
                icon: Icons.lock_outline,
              ),
              SizedBox(height: 20),
              AppButton(
                buttonName: "Register",
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  final name = nameController.text;
                  if (email.isEmpty || password.isEmpty || name.isEmpty) {
                    showErrorDialog(
                      content: "Fields Cannot be empty",
                      context: context,
                    );
                  } else {
                    context.read<AuthBloc>().add(
                      AuthEventDriverRegister(
                        email: email,
                        password: password,
                        name: name,
                        role: UserRole.driver.name,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(
                  "Already have an account, Login here",
                  style: TextStyle(color: AppColors.backgroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
