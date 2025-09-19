import 'package:flutter/material.dart';
import 'package:here4u/mvvm/data/services/user_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  Future<String?> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      await _userService.registerWithEmail(email, password, name);
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }
}
