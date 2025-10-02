import 'package:here4u/mvvm/data/services/journal_service.dart';
import 'package:here4u/models/journal.dart';

class JournalRepository {
  final JournalService _service;

  JournalRepository(this._service);

  Future<void> saveJournal(Journal journal) {
    return _service.saveJournal(journal);
  }

  Future<List<Journal>> getJournals(String userId) {
    return _service.getJournals(userId);
  }

  Future<void> deleteJournal(String journalId) {
    return _service.deleteJournal(journalId);
  }

  Future<void> updateSharedWithTherapist(
      String journalId, bool shared) {
    return _service.updateSharedWithTherapist(journalId, shared);
  }
}
