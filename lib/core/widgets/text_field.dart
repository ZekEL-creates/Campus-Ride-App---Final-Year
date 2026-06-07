import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String topHint;
  final String hintText;
  final IconData icon;
  final bool? obscureText;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.topHint,
    required this.hintText,
    required this.icon,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(children: [Icon(icon), SizedBox(width: 10), Text(topHint)]),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscureText ?? false,

            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
