import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/error_dialog.dart';
import 'package:ridesharingapp/core/routes/routes.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/auth_view_card.dart';
import 'package:ridesharingapp/core/widgets/text_field.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_exceptions.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthViewCard(),
            SizedBox(height: 20),
            Text(
              "Login To Your Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 75, 75, 75),
              ),
            ),
            SizedBox(height: 20),
            AppTextField(
              controller: emailController,
              topHint: "Enter Your Email",
              hintText: "Email",
              icon: Icons.email_outlined,
            ),
            SizedBox(height: 20),
            AppTextField(
              controller: passwordController,
              topHint: "Enter Your Password",
              hintText: "********",
              icon: Icons.lock_outline,
            ),
            SizedBox(height: 20),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is InvalidCredentialAuthException) {
                    showDialog(
                      context: context,
                      builder: (context) => ShowErrorDialog(
                        title: "Invalid Credentials",
                        content: "Please check and try again",
                      ),
                    );
                  } else if (state is GenericAuthException) {
                    showDialog(
                      context: context,
                      builder: (context) => ShowErrorDialog(
                        title: "Authentication Error",
                        content: "An error has occured",
                      ),
                    );
                  }
                }
              },
              child: AppButton(
                buttonName: "Login",
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;

                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
              ),
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(selectRole);
              },
              child: Text(
                "Don't have an account, Register here",
                style: TextStyle(color: AppColors.backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
