import 'package:flutter/foundation.dart';
import 'package:here4u/models/emotion_entity.dart';


class IdentifyEmotionsViewModel extends ChangeNotifier {
  final List<EmotionEntity> emotions = SeedEmotions.list;

  EmotionEntity? selectedEmotion;

  void selectEmotion(EmotionEntity emotion) {
    selectedEmotion = emotion;
    notifyListeners();
  }

  bool confirmSelection() {
    return selectedEmotion != null;
  }
}
