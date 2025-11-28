import 'package:flutter/material.dart';
import 'package:here4u/mvvm/data/repository/journal_repository.dart';
import 'package:here4u/mvvm/data/services/journal_service.dart';
import 'package:here4u/models/journal.dart';

class JournalListViewModel extends ChangeNotifier {
  final JournalRepository _repo;

  List<Journal> _journals = [];
  bool _isLoading = false;
  String? _errorMessage;

  JournalListViewModel({JournalRepository? repository, required String userId})
      : _repo = repository ?? JournalRepository(JournalService()) {
    // 👇 Automatically load journals when the ViewModel is created
    loadJournals(userId);
  }

  List<Journal> get journals => _journals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Loads all journals for the given user
  Future<void> loadJournals(String userId) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      _journals = await _repo.getJournals(userId);

    } catch (e) {
      _errorMessage = "Failed to load journals: $e";
    } finally {
      _isLoading = false; 
    }
    notifyListeners();
  }

  /// Optional: helper to get a formatted date
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
