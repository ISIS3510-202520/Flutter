import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/data/repository/emergency_contact_repository.dart';
import 'package:here4u/mvvm/data/services/emergency_contact_service.dart';
import 'package:here4u/mvvm/ui/view/achievements/achievements_view.dart';
import 'package:here4u/mvvm/ui/view_model/achievements_view_model.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view/profile/profile_view.dart';
import 'package:here4u/mvvm/ui/view_model/profile_view_model.dart';
import 'auth_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';

class HomeViewModel extends ChangeNotifier {
  final bool showOfflineFallbackOnStart;

  HomeViewModel({this.showOfflineFallbackOnStart = false});
  final _repository = EmergencyContactRepository(EmergencyContactService());
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  String getMoodButtonText() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 0 && hour < 12) {
      return "How are you feeling this morning?";
    } else if (hour >= 12 && hour < 18) {
      return "How are you feeling today?";
    } else {
      return "How are you feeling tonight?";
    }
  }

  // Navigation methods
  void onTapProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => ProfileViewModel(), // Remove ..init() call
          child: const ProfileView(),
        ),
      ),
    );
  }

  void onTapAchievements(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => AchievementsViewModel(),
        child: const AchievementsView(),
      ),
    ),
  );
}


  void onTapExercises(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Daily exercises: soon!")),
    );
  }

  Future<void> onTapEmergency(
    BuildContext context, {
    required void Function(List<EmergencyContact>) onNavigate,
  }) async {
    try {
      AuthViewModel authViewModel = context.read<AuthViewModel>();
      final uId = authViewModel.currentUser?.uid;

      debugPrint('[HomeViewModel] User ID: $uId');

      List<EmergencyContact> contacts = await _repository.getContacts(uId!);

      debugPrint('[HomeViewModel] About to log analytics event with ${contacts.length} contacts');

      await _analytics.logEvent(
        name: 'emergency_view_accessed',
        parameters: {
          'user_id': uId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'emergency_contacts_count': contacts.length,
        },
      );

      debugPrint('[HomeViewModel] Analytics events logged successfully');
      
      // Use callback for navigation
      onNavigate(contacts);
    } catch (e) {
      debugPrint('[HomeViewModel] Error accessing emergency view: $e');

      await _analytics.logEvent(
        name: 'emergency_view_error',
        parameters: {
          'error': e.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  /// If a valid cached session is available, show a small SnackWarning to the user.
  void showOfflineFallbackSnack(BuildContext context) {
    try {
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.hasValidCachedToken) {
        SnackWarning.show(context, 'Offline session available - limited features enabled');
      }
    } catch (e) {
      debugPrint('[HomeViewModel] Error showing offline fallback snack: $e');
    }
  }

  // Add method to update streak via AuthViewModel
  Future<void> updateStreak(BuildContext context, int newStreak) async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.updateStreak(newStreak);
  }
}
