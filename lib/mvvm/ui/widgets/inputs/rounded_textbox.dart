import 'package:flutter/material.dart';

class RoundedTextbox extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const RoundedTextbox({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        validator: validator,
      ),
    );
  }
}