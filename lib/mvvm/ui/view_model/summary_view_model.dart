import 'package:flutter/material.dart';
import 'package:here4u/models/summary_request.dart';
import 'package:here4u/mvvm/data/repository/summary_request_repository.dart';
import 'package:here4u/mvvm/data/services/summary_request_service.dart';

class SummaryViewModel extends ChangeNotifier {
  final SummaryRequestRepository _repo;

  SummaryRequest? _req;           // entidad enriquecida con summaryText
  String commonFeeling = 'insert most common feeling this week';

  SummaryViewModel({SummaryRequestRepository? repository})
      : _repo = repository ?? SummaryRequestRepository(SummaryRequestService());

  Future<void> init({String userId = 'me'}) async {
    final now = DateTime.now();
    final request = SummaryRequest.create(
      userId: userId,
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
    );

    // En el futuro, el commonFeeling puede venir del pipeline también.
    commonFeeling = '';

    _req = await _repo.generateFromRequest(request);
    notifyListeners();
  }

  // ==================== Parsing helpers ====================

  String get summaryText => _req?.summaryText ?? '';

  /// Extrae el bloque "Highlights:" del summaryText (si existe).
  String get highlights {
    return _extractSection(summaryText, 'Highlights');
  }

  /// Extrae el bloque "Insights:" del summaryText (si existe).
  String get insights {
    return _extractSection(summaryText, 'Insights');
  }

  /// Busca una sección con encabezado seguido de texto hasta el siguiente encabezado o fin.
  String _extractSection(String text, String header) {
    final pattern = RegExp(
      r'(^|\n)' + RegExp.escape(header) + r':\s*\n([\s\S]*?)(?=\n[A-Za-z ]+:\s*\n|$)',
      multiLine: true,
    );
    final match = pattern.firstMatch(text);
    if (match != null && match.groupCount >= 2) {
      return match.group(2)!.trim();
    }
    // Fallback: si no existe el header, retorna todo el texto
    return text.trim().isEmpty ? '[no data]' : text.trim();
  }

  void onTapBack(BuildContext context) => Navigator.of(context).pop();
}
