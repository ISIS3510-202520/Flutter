import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'auth_view_model.dart';

class RecoverPasswordViewModel extends ChangeNotifier {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool isOnline = true;
  bool isLoading = false;

  RecoverPasswordViewModel() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectivity(results);
      _connectivitySub = Connectivity().onConnectivityChanged.listen(_updateConnectivity);
    } catch (e) {
      // If connectivity plugin fails, default to online
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

  Future<String?> recoverPassword(String email, BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      isOnline = false;
      notifyListeners();
      return 'No internet connection. Waiting for connectivity...';
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await authViewModel.sendPasswordReset(email);
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      if (e is SocketException || e.toString().toLowerCase().contains('network') || e.toString().toLowerCase().contains('socket')) {
        isOnline = false;
        notifyListeners();
        return 'Network error. Waiting for connectivity...';
      }
      notifyListeners();
      return e.toString();
    }
  }
}

