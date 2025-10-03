import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view/profile/profile_view.dart';
import 'package:here4u/mvvm/ui/view_model/profile_view_model.dart';
import 'auth_view_model.dart';

class HomeViewModel extends ChangeNotifier {

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Achievements: soon!")),
    );
  }

  void onTapExercises(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Daily exercises: soon!")),
    );
  }

  void onTapEmergency(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency: soon!")),
    );
  }

  // Add method to update streak via AuthViewModel
  Future<void> updateStreak(BuildContext context, int newStreak) async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.updateStreak(newStreak);
  }
}
