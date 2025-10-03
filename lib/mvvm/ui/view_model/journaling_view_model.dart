import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/models/journal.dart';
import 'package:here4u/models/emotion.dart';
import 'package:here4u/mvvm/data/repository/journal_repository.dart';
import 'package:here4u/mvvm/data/services/journal_service.dart';
import 'auth_view_model.dart';

class JournalingViewModel extends ChangeNotifier {
  final Emotion emotion;
  final JournalRepository _repository;

  Journal? _currentEntry;
  Journal? get currentEntry => _currentEntry;

  JournalingViewModel({
    required this.emotion,
  }) : _repository = JournalRepository(JournalService());

  Future<bool> addToJournal(String text, BuildContext context) async {
    if (text.trim().isEmpty) return false;

    try {
      final authViewModel = context.read<AuthViewModel>();
      final userId = authViewModel.currentUser?.uid;
      
      if (userId == null) return false;

      // Create local journal object
      _currentEntry = Journal.create(
        userId: userId,
        emotionId: emotion.id,
        description: text,
      );

      // Save journal entry
      await _repository.saveJournal(_currentEntry!);

      // Calculate and update streak
      await _updateStreakAfterEntry(context);

      print('[JournalingViewModel] Journal entry saved for emotion: ${emotion.name}');
      return true;
      
    } catch (e) {
      print('[JournalingViewModel] Error saving journal: $e');
      return false;
    }
  }

  Future<void> _updateStreakAfterEntry(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    
    // Calculate new streak based on last entry date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastEntry = authViewModel.userEntity?.lastEntryDate;
    final lastEntryDate = lastEntry != null 
        ? DateTime(lastEntry.year, lastEntry.month, lastEntry.day)
        : null;

    int newStreak = authViewModel.currentStreak;

    if (lastEntryDate == null) {
      // First entry ever
      newStreak = 1;
      print('[JournalingViewModel] First journal entry ever, streak: $newStreak');
    } else if (lastEntryDate.isAtSameMomentAs(today)) {
      // Entry already made today, keep current streak
      print('[JournalingViewModel] Journal entry already made today, keeping streak: $newStreak');
    } else if (lastEntryDate.isAtSameMomentAs(today.subtract(Duration(days: 1)))) {
      // Entry was yesterday, continue streak
      newStreak = authViewModel.currentStreak + 1;
      print('[JournalingViewModel] Continuing streak from yesterday: $newStreak');
    } else {
      // Gap in entries, reset streak
      newStreak = 1;
      print('[JournalingViewModel] Gap in entries, resetting streak to: $newStreak');
    }

    // Update streak and last entry date
    await authViewModel.updateStreak(newStreak);
  }

  // Add method for when user completes the journaling flow
  Future<bool> completeJournaling(String text, BuildContext context) async {
    final success = await addToJournal(text, context);
    
    if (success) {
      notifyListeners();
      return true;
    }
    
    return false;
  }
}
