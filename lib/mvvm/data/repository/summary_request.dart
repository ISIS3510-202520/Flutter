/// Repositorio de Summaries (stub sin BD).
/// Más adelante aquí conectarás Firebase/tu API para generar resúmenes reales.

class SummaryResult {
  final String commonFeeling;
  final String highlights;
  final String insights;

  SummaryResult({
    required this.commonFeeling,
    required this.highlights,
    required this.insights,
  });
}

class SummaryRequestRepository {
  SummaryRequestRepository();

  /// Simula una generación de resumen local (sin red/BD).
  Future<SummaryResult> generateLocalDemo() async {
    // Pequeño delay para simular trabajo
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return SummaryResult(
      commonFeeling: 'Calm / Tranquilo',
      highlights:
          '- Journals con “calm” en 4 de 7 días\n- Mayor energía el jueves\n- Trigger frecuente: “clases”',
      insights:
          '1) Programa un breathing 4-7-8 antes de dormir\n2) Agenda journaling corto tras clases\n3) Prueba un paseo breve en la tarde',
    );
  }

  /// Interfaz pensada para futuro: genera summary entre [start] y [end].
  Future<SummaryResult> generateSummary({
    required DateTime start,
    required DateTime end,
    String userId = 'me',
  }) async {
    // TODO: reemplazar por lógica real (consulta journals/emotions)
    return generateLocalDemo();
  }
}
