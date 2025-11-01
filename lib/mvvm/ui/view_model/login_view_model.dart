import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'auth_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool isOnline = true;
  bool isLoading = false;

  LoginViewModel() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectivity(results);
      _connectivitySub = Connectivity().onConnectivityChanged.listen(_updateConnectivity);
    } catch (e) {
      isOnline = true;
      notifyListeners();
    }
  }

  void _updateConnectivity(List<ConnectivityResult> results) {
    final wasOnline = isOnline;
    isOnline = results.any((r) => r != ConnectivityResult.none);
    if (isOnline != wasOnline) notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
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

  Future<void> refreshEmailVerification(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.refreshEmailVerification();
  }

  Future<void> loginWithCallback(
    String email,
    String password,
    BuildContext context,
    void Function(String? result) onComplete,
  ) async {
    // Online-first: if offline, update state and return immediately
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      isOnline = false;
      notifyListeners();
      onComplete('No internet connection');
      return;
    }

    final authViewModel = context.read<AuthViewModel>();

    isLoading = true;
    notifyListeners();

    try {
      await refreshEmailVerification(context);
      final result = await authViewModel.signInWithEmail(email, password);
      isLoading = false;
      notifyListeners();
      onComplete(result);
    } catch (e) {
      isLoading = false;
      if (e is SocketException || e.toString().toLowerCase().contains('network') || e.toString().toLowerCase().contains('socket')) {
        isOnline = false;
        notifyListeners();
        onComplete('Network error');
      } else {
        onComplete(e.toString());
      }
    }
  }
}