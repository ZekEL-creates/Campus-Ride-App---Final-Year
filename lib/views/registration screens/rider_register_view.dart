import 'package:flutter/material.dart';
import 'package:ridesharingapp/core/constants/colors.dart';
import 'package:ridesharingapp/core/routes/routes.dart';
import 'package:ridesharingapp/core/widgets/app_button.dart';
import 'package:ridesharingapp/core/widgets/auth_view_card.dart';
import 'package:ridesharingapp/core/widgets/text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    nameController = TextEditingController();
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
              "Register As A Rider",
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
              hintText: "name",
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
              hintText: "********",
              icon: Icons.lock_outline,
            ),
            SizedBox(height: 20),
            AppButton(buttonName: "Register", onPressed: () {}),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(login);
              },
              child: Text(
                "Already have an account, Login here",
                style: TextStyle(color: AppColors.backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
