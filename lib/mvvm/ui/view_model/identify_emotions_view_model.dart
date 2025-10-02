import 'package:flutter/foundation.dart';
import 'package:here4u/models/emotion.dart';
import 'package:here4u/models/seed_emotions.dart';


class IdentifyEmotionsViewModel extends ChangeNotifier {
  final List<Emotion> emotions = SeedEmotions.list;
  final String userId; 

  Emotion? selectedEmotion;

  IdentifyEmotionsViewModel({required this.userId});

  void selectEmotion(Emotion emotion) {
    selectedEmotion = emotion;
    notifyListeners();
  }

  bool confirmSelection() {
    return selectedEmotion != null;
  }
}
