import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'auth_view_model.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';
import 'package:firebase_performance/firebase_performance.dart';

class RegisterViewModel extends ChangeNotifier {
  AuthViewModel? _authViewModel;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool isOnline = true;
  bool isLoading = false;

  void setAuthViewModel(AuthViewModel authViewModel) {
    _authViewModel = authViewModel;
  }

  RegisterViewModel() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectivity(results);
      _connectivitySub = Connectivity().onConnectivityChanged.listen(_updateConnectivity);
    } catch (e) {
      // If connectivity plugin fails for any reason, default to online to avoid blocking.
      isOnline = true;
      notifyListeners();
    }
  }

  void _updateConnectivity(List<ConnectivityResult> results) {
    final wasOnline = isOnline;
    // If any reported connection type is not `none`, consider online.
    isOnline = results.any((r) => r != ConnectivityResult.none);
    if (isOnline != wasOnline) notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
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

    // Check connectivity first (online-first). If offline, mark offline and update UI.
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      isOnline = false;
      notifyListeners();
      SnackWarning.show(context, 'No internet connection. Waiting for connectivity...');
      return;
    }

    // Show loading dialog and disable interactions via isLoading
    isLoading = true;
    notifyListeners();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final trace = FirebasePerformance.instance.newTrace("app_flutter_register");
    await trace.start();

    String? error;
    try {
      error = await registerWithEmail(email, password, name);
    } catch (e) {
      // If a socket exception or obvious network failure, mark offline and inform user.
      if (e is SocketException || e.toString().toLowerCase().contains('network') || e.toString().toLowerCase().contains('socket')) {
        isOnline = false;
        notifyListeners();
        SnackWarning.show(context, 'Network error. You appear to be offline. Waiting for connectivity...');
      } else {
        SnackWarning.show(context, 'Registration failed: ${e.toString()}');
      }
      error = e.toString();
    }

    if (!context.mounted) return;

    Navigator.of(context).pop(); // Remove loading dialog

    isLoading = false;
    notifyListeners();

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
