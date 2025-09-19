import 'package:flutter/material.dart';

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
    // Aún no hay pantalla -> placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile info: próximamente")),
    );
  }

  void onTapAchievements(BuildContext context) {
    // Aún no hay pantalla -> placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Achievements: próximamente")),
    );
  }

  void onTapRegisterMood(BuildContext context) {
    // Navega a la vista existente de IdentifyEmotions
    Navigator.of(context).pushNamed('/identify');
  }

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
