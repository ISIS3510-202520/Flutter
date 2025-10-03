import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  Future<String?> login(String email, String password, BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    return await authViewModel.signInWithEmail(email, password);
  }

  Future<String?> sendEmailVerification(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    final user = authViewModel.currentUser;
    
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        return null;
      } catch (e) {
        return 'Error sending verification email: ${e.toString()}';
      }
    }
    return 'No user to send verification to';
  }
}