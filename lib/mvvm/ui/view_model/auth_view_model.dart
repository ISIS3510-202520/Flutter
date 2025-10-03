import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_entity.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;
  UserEntity? _userEntity;
  bool _isLoading = true;

  // Getters
  User? get currentUser => _currentUser;
  UserEntity? get userEntity => _userEntity;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;
  String get displayName => _userEntity?.displayName ?? _currentUser?.displayName ?? 'User';
  int get currentStreak => _userEntity?.currentStreak ?? 0;
  int get longestStreak => _userEntity?.longestStreak ?? 0;

  AuthViewModel() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _auth.authStateChanges().listen((User? user) async {
      print('[AuthViewModel] Auth state changed: ${user?.uid}');
      _currentUser = user;
      
      if (user != null) {
        await _loadUserData();
      } else {
        _userEntity = null;
      }
      
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;
    
    try {
      print('[AuthViewModel] Loading user data for: ${_currentUser!.uid}');
      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      
      if (doc.exists) {
        _userEntity = UserEntity.fromJson(doc.data()!);
        print('[AuthViewModel] Loaded user data: ${_userEntity?.displayName}');
      } else {
        print('[AuthViewModel] No user document found');
      }
    } catch (e) {
      print('[AuthViewModel] Error loading user data: $e');
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection('users')
            .doc(credential.user!.uid)
            .update({'lastLogin': Timestamp.fromDate(DateTime.now())});
      }

      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> registerWithEmail(String email, String password, String displayName) async {
    try {
      final existing = await _firestore.collection('users')
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

        await _firestore.collection('users')
            .doc(user.uid)
            .set(userEntity.toJson());
        
        await user.sendEmailVerification();
        await user.updateDisplayName(displayName);
        
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
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('[AuthViewModel] Sign out error: $e');
    }
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
    notifyListeners();
  }

  Future<void> updateStreak(int newStreak) async {
    if (_currentUser == null || _userEntity == null) return;

    try {
      print('[AuthViewModel] Updating streak to: $newStreak');
      
      final updateData = {
        'currentStreak': newStreak,
        'longestStreak': newStreak > _userEntity!.longestStreak ? newStreak : _userEntity!.longestStreak,
        'lastEntryDate': Timestamp.fromDate(DateTime.now()),
      };
      
      await _firestore.collection('users').doc(_currentUser!.uid).update(updateData);

      _userEntity = _userEntity!.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > _userEntity!.longestStreak ? newStreak : _userEntity!.longestStreak,
        lastEntryDate: DateTime.now(),
      );
      
      print('[AuthViewModel] Streak updated successfully: current=$newStreak, longest=${_userEntity!.longestStreak}');
      notifyListeners();
    } catch (e) {
      print('[AuthViewModel] Error updating streak: $e');
      rethrow;
    }
  }
}