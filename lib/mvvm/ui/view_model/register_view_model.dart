import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_view_model.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';
import 'package:firebase_performance/firebase_performance.dart';

class RegisterViewModel extends ChangeNotifier {
  AuthViewModel? _authViewModel;

  void setAuthViewModel(AuthViewModel authViewModel) {
    _authViewModel = authViewModel;
  }

  Future<String?> registerWithEmail(String email, String password, String name) async {
    if (_authViewModel == null) {
      throw Exception('AuthViewModel not set');
    }
    return await _authViewModel!.registerWithEmail(email, password, name);
  }

  Future<void> performRegistration(
    String email, 
    String password, 
    String name, 
    BuildContext context
  ) async {
    // Set the AuthViewModel reference
    _authViewModel = context.read<AuthViewModel>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final trace = FirebasePerformance.instance.newTrace("app_flutter_register");
    await trace.start();

    final error = await registerWithEmail(email, password, name);
    
    if (!context.mounted) return;
    
    Navigator.of(context).pop(); // Remove loading dialog
    
    if (error == null) {
      await trace.stop();
      if (!context.mounted) return;
      SnackWarning.show(
        context,
        'Please check your email to verify your account.',
      );
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthView()),
        (_) => false,
      );
    } else {
      if (!context.mounted) return;
      SnackWarning.show(context, error);
    }
  }
}
