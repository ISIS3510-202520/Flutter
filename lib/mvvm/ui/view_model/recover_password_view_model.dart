import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_view_model.dart';

class RecoverPasswordViewModel extends ChangeNotifier {
  Future<String?> recoverPassword(String email, BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    return await authViewModel.sendPasswordReset(email);
  }
}
