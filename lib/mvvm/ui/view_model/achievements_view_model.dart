import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/achievements/achievements_view.dart';
import 'package:provider/provider.dart';

class AchievementsViewModel extends ChangeNotifier {
  // Aquí luego conectas tu backend
  // Mantén esta estructura para que sea fácil de actualizar
  final List<String> _achievements = [
    "Achievement 1",
    "Achievement 2",
    "Achievement 3",
    "Achievement 4",
  ];

  List<String> get achievements => _achievements;

  // Más adelante podrás reemplazar esto con Firestore o API call
  Future<void> loadAchievements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }


}

