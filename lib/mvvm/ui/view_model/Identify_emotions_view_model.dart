import 'package:flutter/foundation.dart';

class IdentifyEmotionsViewModel extends ChangeNotifier {
  
  final List<String> emotions = ["Happy", "Sad", "Angry", "Excited", "Calm"];

  
  String? selectedEmotion;

  void selectEmotion(String emotion) {
    selectedEmotion = emotion;
    notifyListeners();
  }

  bool confirmSelection() {
    if (selectedEmotion == null) return false;
    return true;
  }
}
