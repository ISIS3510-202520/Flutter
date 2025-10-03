import 'package:here4u/models/journal.dart';
import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';

/// Repository: orquesta al service y deja la UI desacoplada.
class SummaryRequestRepository {
  final SummaryRequestService _service;

  SummaryRequestRepository(this._service);

  Future<SummaryRequest> generateFromRequest(SummaryRequest request, List<Journal> journals) {
    return _service.generateFromRequest(request, journals);
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
