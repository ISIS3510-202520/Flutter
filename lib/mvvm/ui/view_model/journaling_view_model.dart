import 'package:flutter/foundation.dart';
import 'package:here4u/models/journal.dart';
import 'package:here4u/models/emotion.dart';
import 'package:here4u/mvvm/data/repository/journal_repository.dart';
import 'package:here4u/mvvm/data/services/journal_service.dart';

class JournalingViewModel extends ChangeNotifier {
  final Emotion emotion;
  final String userId;
  final JournalRepository _repository;

  Journal? _currentEntry;
  Journal? get currentEntry => _currentEntry;

  JournalingViewModel({
    required this.emotion,
    required this.userId,
  }) : _repository = JournalRepository(JournalService());

  Future<void> addToJournal(String text) async {
    if (text.trim().isEmpty) return;

    // Create local journal object
    _currentEntry = Journal.create(
      userId: userId,
      emotionId: emotion.id,
      description: text,
    );

    await _repository.saveJournal(_currentEntry!);

  }
}
