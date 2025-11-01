import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_entity.dart';
import 'package:here4u/mvvm/data/local/auth_token_lru_cache.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  User? _currentUser;
  UserEntity? _userEntity;
  bool _isLoading = true;

  // Session tracking variables
  DateTime? _sessionStartTime;
  int _totalSessionDuration = 0; // in seconds

  // Getters
  User? get currentUser => _currentUser;
  UserEntity? get userEntity => _userEntity;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;
  String get displayName =>
      _userEntity?.displayName ?? _currentUser?.displayName ?? 'User';
  int get currentStreak => _userEntity?.currentStreak ?? 0;
  int get longestStreak => _userEntity?.longestStreak ?? 0;
  int get totalSessionDuration => _totalSessionDuration;

  AuthViewModel() {
    _initializeAuth();
    _initTokenCache();
  }

  final AuthTokenLRUCache _tokenCache = AuthTokenLRUCache();

  Future<void> _initTokenCache() async {
    try {
      await _tokenCache.loadFromStorage();
      debugPrint('[AuthViewModel] Loaded token cache (size=${_tokenCache.size})');
    } catch (e) {
      debugPrint('[AuthViewModel] Error initializing token cache: $e');
    }
  }

  void _initializeAuth() {
    _auth.authStateChanges().listen((User? user) async {
      
      debugPrint('[AuthViewModel] Auth state changed: ${user?.uid}');
      _currentUser = user;

      if (user != null) {
        await _loadUserData();
        _startSession(); // Start tracking when user logs in
      } else {
        _endSession(); // Stop tracking when user logs out
        _userEntity = null;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  void _startSession() {
    _sessionStartTime = DateTime.now();
    debugPrint('[AuthViewModel] Session started at: $_sessionStartTime');
    
    // Log session start - using custom event name
    _analytics.logEvent(
      name: 'user_session_start',
      parameters: {
        'timestamp': _sessionStartTime!.millisecondsSinceEpoch,
        'user_id': _currentUser?.uid ?? 'unknown',
      },
    );
  }

  void _endSession() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!).inSeconds;
      _totalSessionDuration += sessionDuration;
      
      debugPrint('[AuthViewModel] Session ended. Duration: ${sessionDuration}s, Total: ${_totalSessionDuration}s');
      
      // Log session end - using custom event name
      _analytics.logEvent(
        name: 'user_session_end',
        parameters: {
          'session_duration_seconds': sessionDuration,
          'total_session_duration_seconds': _totalSessionDuration,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      // Only reset session start time, keep total duration
      _sessionStartTime = null;
      // Don't reset _totalSessionDuration here - it should persist
    }
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      debugPrint('[AuthViewModel] Loading user data for: ${_currentUser!.uid}');
      final doc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (doc.exists) {
        _userEntity = UserEntity.fromJson(doc.data()!);
        debugPrint(
          '[AuthViewModel] Loaded user data: ${_userEntity?.displayName}',
        );
      } else {
        debugPrint('[AuthViewModel] No user document found');
      }
    } catch (e) {
      debugPrint('[AuthViewModel] Error loading user data: $e');
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).update({
          'lastLogin': Timestamp.fromDate(DateTime.now()),
        });
      }

      await _analytics.logLogin(loginMethod: 'email');
      await _analytics.logEvent(
        name: 'user_login',
        parameters: {
          'method': 'email',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      // Persist auth token into the secure LRU cache for offline fallback.
      try {
        final user = credential.user;
        if (user != null) {
          final idTokenResult = await user.getIdTokenResult();
          final tokenString = idTokenResult.token ?? await user.getIdToken();
          final issuedAt = idTokenResult.issuedAtTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
          final expiresAt = idTokenResult.expirationTime?.millisecondsSinceEpoch ?? DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

          final authToken = AuthToken(
            id: user.uid,
            token: tokenString ?? '',
            issuedAtMillis: issuedAt,
            expiresAtMillis: expiresAt,
          );

          await _tokenCache.put(authToken);
          debugPrint('[AuthViewModel] Saved token for user ${user.uid} to cache');
        }
      } catch (e) {
        debugPrint('[AuthViewModel] Failed to save token to cache: $e');
      }

      return null; // Success
    } catch (e) {
      await _analytics.logEvent(
        name: 'login_failed',
        parameters: {
          'error': e.toString(),
          'method': 'email',
        },
      );
      return e.toString();
    }
  }

  Future<String?> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final existing = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existing.docs.isNotEmpty) {
        return 'Email already registered';
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final userEntity = UserEntity(
          id: user.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          currentStreak: 0,
          longestStreak: 0,
          lastEntryDate: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userEntity.toJson());

        await user.sendEmailVerification();
        await user.updateDisplayName(displayName);

        await _analytics.logSignUp(signUpMethod: 'email');
        await _analytics.logEvent(
          name: 'user_registration',
          parameters: {
            'method': 'email',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );

        return null; // Success
      }

      return 'Failed to create user';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      
      await _analytics.logEvent(
        name: 'password_reset_requested',
        parameters: {
          'method': 'email',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      // Calculate final session duration before logout
      int finalSessionDuration = 0;
      if (_sessionStartTime != null) {
        finalSessionDuration = DateTime.now().difference(_sessionStartTime!).inSeconds;
        _totalSessionDuration += finalSessionDuration;
      }

      // Store total before signOut (which triggers _endSession)
      final totalTimeSpent = _totalSessionDuration;

      // Clear any persisted auth tokens so the app does not fall back to
      // an offline cached session after the user explicitly signs out.
      try {
        await _tokenCache.clear();
        debugPrint('[AuthViewModel] Cleared auth token cache on sign out');
      } catch (e) {
        debugPrint('[AuthViewModel] Failed to clear token cache: $e');
      }

      await _auth.signOut();

      await _analytics.logEvent(
        name: 'user_logout',
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'session_duration_seconds': finalSessionDuration,
          'total_time_in_app_seconds': totalTimeSpent,
        },
      );

      debugPrint('[AuthViewModel] User logged out. Total session time: ${totalTimeSpent}s');
      
      // Reset total duration only after logout analytics
      _totalSessionDuration = 0;
      
    } catch (e) {
      debugPrint('[AuthViewModel] Sign out error: $e');
    }
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
    notifyListeners();
  }

  Future<void> updateStreak(int newStreak) async {
    if (_currentUser == null || _userEntity == null) return;

    try {
      debugPrint('[AuthViewModel] Updating streak to: $newStreak');

      final updateData = {
        'currentStreak': newStreak,
        'longestStreak': newStreak > _userEntity!.longestStreak
            ? newStreak
            : _userEntity!.longestStreak,
        'lastEntryDate': Timestamp.fromDate(DateTime.now()),
      };

      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updateData);

      _userEntity = _userEntity!.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > _userEntity!.longestStreak
            ? newStreak
            : _userEntity!.longestStreak,
        lastEntryDate: DateTime.now(),
      );

      debugPrint(
        '[AuthViewModel] Streak updated successfully: current=$newStreak, longest=${_userEntity!.longestStreak}',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('[AuthViewModel] Error updating streak: $e');
      rethrow;
    }
  }

  Future<void> refreshEmailVerification() async {
    if (_currentUser != null) {
      debugPrint('[AuthViewModel] Refreshing email verification status...');
      await _currentUser!.reload();
      _currentUser = _auth.currentUser;
      debugPrint('[AuthViewModel] Email verified after refresh: ${_currentUser?.emailVerified}');
      notifyListeners();
    }
  }

  /// Returns the most-recent non-expired cached token, or null.
  AuthToken? get firstValidCachedToken => _tokenCache.firstValidToken();

  /// Whether a non-expired cached token exists.
  bool get hasValidCachedToken => firstValidCachedToken != null;

  // Optional: Method to get current session duration while active
  int getCurrentSessionDuration() {
    if (_sessionStartTime != null) {
      return DateTime.now().difference(_sessionStartTime!).inSeconds;
    }
    return 0;
  }
}
