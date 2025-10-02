import 'package:here4u/models/summary_request.dart';

/// Service: aquí irá Firestore/HTTP en el futuro.
/// Por ahora devuelve mocks y SOLO usa `summaryText` para highlights+insights.
class SummaryRequestService {
  /// Genera el resumen (mock) y devuelve la misma entidad enriquecida
  /// con `generatedAt` y `summaryText` (incluye Highlights + Insights).
  Future<SummaryRequest> generateFromRequest(
    SummaryRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();

    // En producción, esto vendría de tu pipeline/LLM.
    final combinedText = '''
Your most common emotion was Happy.

Highlights:
- wipity wupityy 
- fresnack
- fiumbaa


Insights:
1) miau miau miau miauu
2) when wando
3) corri2

'''.trim();

    return request.copyWith(
      generatedAt: now,
      summaryText: combinedText,
    );
  }

  /// Atajo para demos locales
  Future<SummaryRequest> generateLocalDemo() async {
    final now = DateTime.now();
    final req = SummaryRequest.create(
      userId: 'me',
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
    );
    return generateFromRequest(req);
  }
}
