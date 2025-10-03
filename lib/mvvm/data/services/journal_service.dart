import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here4u/models/journal.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a new journal entry to journals collection
  Future<void> saveJournal(Journal journal) async {
    final docRef = await _firestore
        .collection("journals")  
        .add(journal.toMap());

    await docRef.update({"id": docRef.id});
  }

  /// Fetch all journal entries for a given user
  Future<List<Journal>> getJournals(String userId) async {
    final snapshot = await _firestore
        .collection("journals")  
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Journal.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Delete a journal entry
  Future<void> deleteJournal(String journalId) async {
    await _firestore
        .collection("journals")
        .doc(journalId)
        .delete();
  }

  /// Update the `sharedWithTherapist` flag
  Future<void> updateSharedWithTherapist(
      String journalId, bool shared) async {
    await _firestore
        .collection("journals")
        .doc(journalId)
        .update({"sharedWithTherapist": shared});
  }

  /// Fetch all journal entries for a user within a given time range
  Future<List<Journal>> getJournalsInRange(
    String userId, DateTime startDate, DateTime endDate) async {
  final snapshot = await _firestore
      .collection("journals")
      .where("userId", isEqualTo: userId)
      .where("createdAt", isGreaterThanOrEqualTo: startDate)
      .where("createdAt", isLessThanOrEqualTo: endDate)
      .orderBy("createdAt", descending: true)
      .get();

  return snapshot.docs
      .map((doc) => Journal.fromMap(doc.id, doc.data()))
      .toList();
}

}
