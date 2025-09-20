import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view/profile/profile_view.dart';
import 'package:here4u/mvvm/ui/view_model/profile_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  // Estado (mock mientras no hay backend)
  String _displayName = "you"; // puedes luego poblarlo con el nombre real
  int _streakDays = 5;

  String get displayName => _displayName;
  int get streakDays => _streakDays;

  // Setters (por si luego los alimentas desde repo/servicio)
  void setDisplayName(String name) {
    _displayName = name;
    notifyListeners();
  }

  void setStreak(int days) {
    _streakDays = days;
    notifyListeners();
  }

  // Acciones de UI
  void onTapProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => ProfileViewModel()..init(),
          child: const ProfileView(),
        ),
      ),
    );
  }

  void onTapAchievements(BuildContext context) {
    // Aún no hay pantalla -> placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Achievements: próximamente")),
    );
  }

  // void onTapRegisterMood(BuildContext context) {
  //   // Navega a la vista existente de IdentifyEmotions
  //   Navigator.of(context).pushNamed('/identify');
  // }

  void onTapExercises(BuildContext context) {
    // Aún no hay pantalla -> placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Daily exercises: próximamente")),
    );
  }

  void onTapEmergency(BuildContext context) {
    // Aún no hay pantalla -> placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency: próximamente")),
    );
  }
}
