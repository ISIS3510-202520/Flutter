// lib/services/summary_request_service.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here4u/models/journal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:here4u/models/summary_request.dart';

Future<SummaryRequest> isolateGenerateSummary(Map<String, dynamic> args) async {
  final requestMap = args['request'] as Map<String, dynamic>;
  final journalTexts = args['journalTexts'] as String;
  final apiKey = args['apiKey'] as String;
  final model = args['model'] as String;
  final openAIBase = args['openAIBase'] as String;

  final request = SummaryRequest.fromMap("", requestMap);
  final now = DateTime.now();

  final prompt = '''
You are a therapist writing a SINGLE, short, actionable summary text (max. ~180-220 words) that combines:
- Highlights (key points)
- Insights (interpretations/suggested actions)
in a SINGLE output field.

$journalTexts

Instructions:
- Return only the final text (no titles like "Highlights" or "Insights").
- Tone: empathetic, clear, and concrete.
- Include 2-4 bullets with suggested actions at the end.
''';

  final uri = Uri.parse("$openAIBase/responses");
  final body = jsonEncode({
    "model": model,
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

  return request.copyWith(
    generatedAt: now,
    summaryText: combinedText,
  );
}


/// Service: genera summaryText llamando a OpenAI Responses API.
class SummaryRequestService {
  final String _openAIBase = "https://api.openai.com/v1";
  final String _model = "gpt-4o-mini"; // ajusta si usas otro modelo
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SummaryRequest> generateFromRequest(
    SummaryRequest request,
    List<Journal> journals,
  ) async {
    final apiKey = dotenv.env["OPENAI_API_KEY"];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("OPENAI_API_KEY no configurada en .env");
    }

    final journalTexts = journals.map((j) => j.description).join("\n");

    final args = {
      'request': request.toMap(),
      'journalTexts': journalTexts,
      'apiKey': apiKey,
      'model': _model,
      'openAIBase': _openAIBase,
    };

    // Run the heavy backend + AI work in an isolate
    final result = await compute(isolateGenerateSummary, args);

    return result;
  }

  Future<void> saveSummary(SummaryRequest summary) async {
    final docRef = await _firestore
        .collection("SummaryRequests")  
        .add(summary.toMap());

    await docRef.update({"id": docRef.id});
  }

  Future<SummaryRequest?> querySummaryForDate(String userId, DateTime date) async {
  final startOfDay = DateTime.utc(date.year, date.month, date.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final snapshot = await FirebaseFirestore.instance
      .collection("SummaryRequests")
      .where("userId", isEqualTo: userId)
      .where("generatedAt", isGreaterThanOrEqualTo: startOfDay)
      .where("generatedAt", isLessThan: endOfDay)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;

  final doc = snapshot.docs.first;
  return SummaryRequest.fromMap(doc.id, doc.data());
}
}
