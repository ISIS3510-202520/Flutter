import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_view_model.dart';

class RegisterViewModel extends ChangeNotifier {
  Future<String?> registerWithEmail(String email, String password, String name, BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    return await authViewModel.registerWithEmail(email, password, name);
  }
}
