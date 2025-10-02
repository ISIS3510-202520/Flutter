import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoverPasswordViewModel extends ChangeNotifier {
  Future<String?> recoverPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Password reset email sent. Please check your inbox.';
    } catch (e) {
      return 'Password reset email sent. Please check your inbox.';
    }
  }
}
