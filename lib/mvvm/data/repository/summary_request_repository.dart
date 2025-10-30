import 'package:here4u/models/journal.dart';
import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/local/local_database.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';
import 'package:here4u/mvvm/data/local/summary_lru_cache.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SummaryRequestRepository {
  final SummaryRequestService _service;
  final LocalDatabase _localDb = LocalDatabase();
  final SummaryLRUCache _cache = SummaryLRUCache();

  SummaryRequestRepository(this._service);

  Future<SummaryRequest> getOrGenerateSummary(
    SummaryRequest request,
    List<Journal> journals,
  ) async {
    final connectivity = await Connectivity().checkConnectivity();
    bool isOnline = connectivity != ConnectivityResult.none;

    if (isOnline) {
      try {
        
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
        _cache.put(LocalSummary(
          id: summary.id,
          userId: summary.userId,
          startDate: summary.startDate,
          endDate: summary.endDate,
          generatedAt: summary.generatedAt,
          summaryText: summary.summaryText,
        ));

        return summary;
      } catch (e) {
        print("⚠️ Online request failed, falling back to local: $e");
      }
    }

    try {
      final localSummaries = await _localDb.getSummaries(request.userId);
      if (localSummaries.isNotEmpty) {
        final latest = localSummaries.last;
        _cache.put(latest);
        return SummaryRequest(
          id: latest.id,
          userId: latest.userId,
          startDate: latest.startDate,
          endDate: latest.endDate,
          generatedAt: latest.generatedAt,
          summaryText: latest.summaryText ?? "",
        );
      }
    } catch (e) {
      print("⚠️ Local DB lookup failed, falling back to cache: $e");
    }

    try {
      final latest = _cache.latest;
      if (latest != null) {
        return SummaryRequest(
          id: latest.id,
          userId: latest.userId,
          startDate: latest.startDate,
          endDate: latest.endDate,
          generatedAt: latest.generatedAt,
          summaryText: latest.summaryText ?? "",
        );
      }
    } catch (e) {
      print("⚠️ Cache lookup failed: $e");
    }

    return SummaryRequest(
      id: "default",
      userId: request.userId,
      startDate: request.startDate,
      endDate: request.endDate,
      generatedAt: DateTime.now(),
      summaryText:
          "No summary available right now. Please check your internet connection and try again later.",
    );
  }

  Future<void> saveSummary(SummaryRequest summary) async {
    await _service.saveSummary(summary);
    await _localDb.saveLatestSummary(LocalSummary(
      id: summary.id,
      userId: summary.userId,
      startDate: summary.startDate,
      endDate: summary.endDate,
      generatedAt: summary.generatedAt,
      summaryText: summary.summaryText,
    ));
    _cache.put(LocalSummary(
      id: summary.id,
      userId: summary.userId,
      startDate: summary.startDate,
      endDate: summary.endDate,
      generatedAt: summary.generatedAt,
      summaryText: summary.summaryText,
    ));
  }

  Future<SummaryRequest?> getSummaryForDate(String userId, DateTime date) async {
    final snapshot = await _service.querySummaryForDate(userId, date);
    if (snapshot == null) return null;
    return snapshot;
  }
}
