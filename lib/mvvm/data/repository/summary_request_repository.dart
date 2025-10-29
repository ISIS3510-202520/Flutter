import 'package:here4u/models/journal.dart';
import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/local/local_database.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';

class SummaryRequestRepository {
  final SummaryRequestService _service;
  final LocalDatabase _localDb = LocalDatabase();

  SummaryRequestRepository(this._service);

  Future<SummaryRequest> generateFromRequest(
    SummaryRequest request,
    List<Journal> journals,
  ) async {
    final summary = await _service.generateFromRequest(request, journals);

    await _service.saveSummary(summary);

    await _localDb.saveLatestSummary(LocalSummary(
      id: summary.id,
      userId: summary.userId,
      startDate: summary.startDate,
      endDate: summary.endDate,
      generatedAt: summary.generatedAt,
      summaryText: summary.summaryText,
    ));

    final allSummaries = await _localDb.getSummaries(summary.userId);
    print("Local summaries for user ${summary.userId}:");
    for (var s in allSummaries) {
      print("- ${s.id} generated at ${s.generatedAt}");
    }

    return summary;
  }

  Future<void> saveSummary(SummaryRequest summary) {
    return _service.saveSummary(summary);
  }

  // Future<SummaryRequest> generateLocalDemo() {
  //   return _service.generateLocalDemo();
  // }

  Future<SummaryRequest?> getSummaryForDate(String userId, DateTime date) async {
  final snapshot = await _service.querySummaryForDate(userId, date);
  if (snapshot == null) return null;
  return snapshot;
}
}
