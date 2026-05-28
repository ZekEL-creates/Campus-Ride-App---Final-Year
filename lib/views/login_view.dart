import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/dialogs/error_dialog.dart';
import 'package:ridesharingapp/core/dialogs/loading_dialog.dart';
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
  CloseDialog? _closeDialog;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialog;

          //show loader
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialog = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialog = showLoadingDialog(
              context: context,
              text: "Logging In",
            );
          }

          Future.delayed(Duration(milliseconds: 200));

          //handle exceptions
          if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(
              content: "Invalid Credentials",
              context: context,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(content: "Invalid Email", context: context);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              content: "Something went wrong",
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
              SizedBox(height: 13),
              AppTextField(
                controller: passwordController,
                topHint: "Enter Your Password",
                hintText: "********",
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: 20),
              AppButton(
                buttonName: "Login",
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;

                  if (email.isEmpty) {
                    await showErrorDialog(
                      content: "Email Field Cannot be empty",
                      context: context,
                    );
                  } else if (password.isEmpty) {
                    showErrorDialog(
                      content: "Password field cannot be empty",
                      context: context,
                    );
                  } else {
                    context.read<AuthBloc>().add(
                      AuthEventLogIn(email, password),
                    );
                  }
                },
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventShouldRegister());
                  //Navigator.of(context).pushNamed(selectRole);
                },
                child: Text(
                  "Don't have an account, Register here",
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
