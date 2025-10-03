import 'package:cloud_firestore/cloud_firestore.dart';

/// SummaryRequest (según UML):
/// id          : string
/// userId      : string
/// startDate   : timestamp
/// endDate     : timestamp
/// generatedAt : timestamp
/// summaryText : string
class SummaryRequest {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? generatedAt;
  final String summaryText;

  SummaryRequest({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.generatedAt,
    required this.summaryText,
  });

  /// Fábrica para crear una solicitud antes de persistirla
  factory SummaryRequest.create({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SummaryRequest(
      id: "",                // lo asignará la BD en el futuro
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      generatedAt: null,     // se llena cuando se genera el resumen
      summaryText: "",       // se llena cuando se genera el resumen
    );
  }

  SummaryRequest copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? generatedAt,
    String? summaryText,
  }) {
    return SummaryRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      generatedAt: generatedAt ?? this.generatedAt,
      summaryText: summaryText ?? this.summaryText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "startDate": startDate,
      "endDate": endDate,
      "generatedAt": generatedAt,
      "summaryText": summaryText,
    };
  }

  factory SummaryRequest.fromMap(String id, Map<String, dynamic> map) {
  return SummaryRequest(
    id: id,
    userId: map["userId"] ?? "",
    startDate: map["startDate"] != null
        ? (map["startDate"] as Timestamp).toDate()
        : DateTime.now(),
    endDate: map["endDate"] != null
        ? (map["endDate"] as Timestamp).toDate()
        : DateTime.now(),
    generatedAt: map["generatedAt"] != null
        ? (map["generatedAt"] as Timestamp).toDate()
        : null,
    summaryText: map["summaryText"] ?? "",
  );
}
}
