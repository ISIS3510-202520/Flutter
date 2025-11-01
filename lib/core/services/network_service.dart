import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Simple network service that exposes whether the device currently
/// has internet access. It uses connectivity_plus to detect
/// connectivity changes and performs a lightweight DNS lookup
/// to confirm actual internet reachability.
class NetworkService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<dynamic>? _subscription;

  NetworkService() {
    _init();
  }

  Future<void> _init() async {
    await _updateConnectionStatus();
    _subscription = _connectivity.onConnectivityChanged.listen((_) {
      _updateConnectionStatus();
    });
  }

  Future<void> _updateConnectionStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();

      if (result == ConnectivityResult.none) {
        _setOnline(false);
        return;
      }

      // Confirm internet access with a quick DNS lookup.
      // Use a short timeout so this doesn't hang the UI.
      final lookup = await InternetAddress.lookup('example.com').timeout(
        const Duration(seconds: 5),
        onTimeout: () => <InternetAddress>[],
      );

      if (lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty) {
        _setOnline(true);
      } else {
        _setOnline(false);
      }
    } catch (_) {
      _setOnline(false);
    }
  }

  void _setOnline(bool value) {
    if (_isOnline != value) {
      _isOnline = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
