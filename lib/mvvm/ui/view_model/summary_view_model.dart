import 'package:flutter/material.dart';
import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/repository/journal_repository.dart';
import 'package:here4u/mvvm/data/repository/summary_request_repository.dart';
import 'package:here4u/mvvm/data/services/journal_service.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';

class SummaryViewModel extends ChangeNotifier {
  final SummaryRequestRepository _repo;

  SummaryRequest? _req;           // entidad enriquecida con summaryText
  String commonFeeling = 'insert most common feeling this week';

  SummaryViewModel({SummaryRequestRepository? repository})
      : _repo = repository ?? SummaryRequestRepository(SummaryRequestService());

  Future<void> init({required String userId}) async {
    final now = DateTime.now();
    
    final request = SummaryRequest.create(
      userId: userId,
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
    );

    final existingSummary = await _repo.getSummaryForDate(userId, request.endDate);

    if (existingSummary != null) {
    // Reuse existing one
      _req = existingSummary;
    }
    else{final journals = await JournalRepository(JournalService())
      .getJournalsInRange(userId, request.startDate, request.endDate);

    // En el futuro, el commonFeeling puede venir del pipeline también.
    commonFeeling = '';

    _req = await _repo.generateFromRequest(request, journals);
    _repo.saveSummary(_req!);
    }
    notifyListeners();
    
  }

  // ==================== Parsing helpers ====================

  String get summaryText => _req?.summaryText ?? 'Loading...';


  void onTapBack(BuildContext context) => Navigator.of(context).pop();
}
