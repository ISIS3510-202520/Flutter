import 'package:flutter/material.dart';

class RoundedTextbox extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const RoundedTextbox({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}