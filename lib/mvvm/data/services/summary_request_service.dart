// lib/services/summary_request_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:here4u/models/summary_request.dart';

/// Service: genera summaryText llamando a OpenAI Responses API.
class SummaryRequestService {
  final String _openAIBase = "https://api.openai.com/v1";
  final String _model = "gpt-4o-mini"; // ajusta si usas otro modelo

  Future<SummaryRequest> generateFromRequest(
    SummaryRequest request,
  ) async {
    final now = DateTime.now();

    final prompt = '''
You are an analyst writing a SINGLE, short, actionable summary text (max. ~180-220 words) that combines:
- Highlights (key points) and
- Insights (interpretations/suggested actions)
in a SINGLE output field.

User context:
- emotionId: happy
- description: llumi

Instructions:
- Return only the final text (no titles like "Highlights" or "Insights").
- Tone: empathetic, clear, and concrete.
- Include 2-4 bullets with suggested actions at the end.
''';

    final apiKey = dotenv.env["OPENAI_API_KEY"];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("OPENAI_API_KEY no configurada en .env");
    }

    final uri = Uri.parse("$_openAIBase/responses");
    final body = jsonEncode({
      "model": _model,
      "input": prompt,
    });

    final resp = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: body,
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("OpenAI error ${resp.statusCode}: ${resp.body}");
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;

    // --- Extraer texto según el formato mostrado ---
    String combinedText = "";
    if (data["output"] is List && data["output"].isNotEmpty) {
      final firstOutput = data["output"][0];
      if (firstOutput["content"] is List && firstOutput["content"].isNotEmpty) {
        final firstContent = firstOutput["content"][0];
        if (firstContent["text"] is String) {
          combinedText = firstContent["text"].toString().trim();
        }
      }
    }

    if (combinedText.isEmpty) {
      throw Exception("No se pudo extraer el texto de la respuesta: ${resp.body}");
    }

    // --- Devolver entidad enriquecida ---
    return request.copyWith(
      generatedAt: now,
      summaryText: combinedText,
    );
  }
}
