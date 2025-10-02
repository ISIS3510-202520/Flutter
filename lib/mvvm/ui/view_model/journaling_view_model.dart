import 'package:flutter/foundation.dart';
import 'package:here4u/models/journal.dart';
import 'package:here4u/models/emotion.dart';

class JournalingViewModel extends ChangeNotifier {
  final Emotion emotion;
  final String userId; 

  JournalingViewModel(this.emotion, this.userId);

  Journal? _currentEntry;
  Journal? get currentEntry => _currentEntry;

  void addToJournal(String text) {
    if (text.trim().isEmpty) return;

    _currentEntry = Journal.create(
      userId: userId,
      emotionId: emotion.id,
      description: text,
    );

    notifyListeners();
  }
}
