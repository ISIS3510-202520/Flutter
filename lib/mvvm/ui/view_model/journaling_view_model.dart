import 'package:flutter/material.dart';
import 'package:here4u/models/journal.dart';
import 'package:here4u/models/emotion.dart';
import 'package:here4u/mvvm/data/repository/journal_repository.dart';
import 'package:here4u/mvvm/data/services/journal_service.dart';
import 'auth_view_model.dart';

class JournalingViewModel extends ChangeNotifier {
  final Emotion emotion;
  final JournalRepository _repository;
  final AuthViewModel _authViewModel;

  Journal? _currentEntry;
  Journal? get currentEntry => _currentEntry;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  JournalingViewModel({
    required this.emotion,
    required AuthViewModel authViewModel,
  }) : _repository = JournalRepository(JournalService()),
       _authViewModel = authViewModel;

  Future<bool> saveJournal(String text) async {
    if (text.trim().isEmpty) {
      _errorMessage = "Please write something before saving!";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authViewModel.currentUser?.uid;
      
      if (userId == null) {
        _errorMessage = "User not authenticated";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint('[JournalingViewModel] Starting journal save process...');
      debugPrint('[JournalingViewModel] User ID: $userId');
      debugPrint('[JournalingViewModel] Emotion: ${emotion.name} (ID: ${emotion.id})');

      // Create local journal object
      _currentEntry = Journal.create(
        userId: userId,
        emotionId: emotion.id,
        description: text,
      );

      debugPrint('[JournalingViewModel] Created journal entry: ${_currentEntry?.id}');

      // Save journal entry
      await _repository.saveJournal(_currentEntry!);
      debugPrint('[JournalingViewModel] Journal entry saved successfully');

      // Calculate and update streak
      await _updateStreakAfterEntry();
      debugPrint('[JournalingViewModel] Streak update completed');

      _isLoading = false;
      notifyListeners();
      
      debugPrint('[JournalingViewModel] Journal entry saved for emotion: ${emotion.name}');
      return true;
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save journal: ${e.toString()}';
      notifyListeners();
      debugPrint('[JournalingViewModel] Error saving journal: $e');
      debugPrint('[JournalingViewModel] Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  Future<void> _updateStreakAfterEntry() async {
    try {
      debugPrint('[JournalingViewModel] Starting streak update...');
      
      // Calculate new streak based on last entry date
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      debugPrint('[JournalingViewModel] Current date: $today');
      debugPrint('[JournalingViewModel] Current streak: ${_authViewModel.currentStreak}');
      
      final lastEntry = _authViewModel.userEntity?.lastEntryDate;
      debugPrint('[JournalingViewModel] Last entry date from auth: $lastEntry');
      
      final lastEntryDate = lastEntry != null 
          ? DateTime(lastEntry.year, lastEntry.month, lastEntry.day)
          : null;

      debugPrint('[JournalingViewModel] Normalized last entry date: $lastEntryDate');

      int newStreak = _authViewModel.currentStreak;

      if (lastEntryDate == null) {
        // First entry ever
        newStreak = 1;
        debugPrint('[JournalingViewModel] First journal entry ever, streak: $newStreak');
      } else if (lastEntryDate.isAtSameMomentAs(today)) {
        // Entry already made today - but if streak is 0, this means it's the first entry of the day
        if (_authViewModel.currentStreak == 0) {
          newStreak = 1;
          debugPrint('[JournalingViewModel] First entry today, setting streak to: $newStreak');
        } else {
          debugPrint('[JournalingViewModel] Journal entry already made today, keeping streak: $newStreak');
          return; // No need to update if already made entry today and streak > 0
        }
      } else if (lastEntryDate.isAtSameMomentAs(today.subtract(Duration(days: 1)))) {
        // Entry was yesterday, continue streak
        newStreak = _authViewModel.currentStreak + 1;
        debugPrint('[JournalingViewModel] Continuing streak from yesterday: $newStreak');
      } else {
        // Gap in entries, reset streak
        newStreak = 1;
        debugPrint('[JournalingViewModel] Gap in entries, resetting streak to: $newStreak');
      }

      // Update streak and last entry date
      debugPrint('[JournalingViewModel] Updating streak to: $newStreak with date: $today');
      await _authViewModel.updateStreak(newStreak);
      
      debugPrint('[JournalingViewModel] Streak update completed successfully');
      
    } catch (e) {
      debugPrint('[JournalingViewModel] Error updating streak: $e');
      debugPrint('[JournalingViewModel] Stack trace: ${StackTrace.current}');
      // Don't throw here, as the journal was already saved successfully
    }
  }

  // Keep existing methods for backward compatibility
  Future<bool> addToJournal(String text, BuildContext context) async {
    return await saveJournal(text);
  }

  Future<bool> completeJournaling(String text, BuildContext context) async {
    final success = await saveJournal(text);
    
    if (success) {
      notifyListeners();
      return true;
    }
    
    return false;
  }
}