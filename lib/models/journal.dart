

class Journal {
  final String id;                  // Firestore document ID
  final String userId;              // Firebase user UID
  final String emotionId;           // ID of the selected emotion
  final String description;         // User's journal text
  final DateTime createdAt;         // Timestamp of creation
  final bool sharedWithTherapist;   // Whether entry was shared with therapist

  Journal({
    required this.id,
    required this.userId,
    required this.emotionId,
    required this.description,
    required this.createdAt,
    required this.sharedWithTherapist,
  });

  /// Factory to create a new journal entry before saving
  factory Journal.create({
    required String userId,
    required String emotionId,
    required String description,
    bool sharedWithTherapist = false,
  }) {
    return Journal(
      id: "", // Firestore will auto-generate this
      userId: userId,
      emotionId: emotionId,
      description: description,
      createdAt: DateTime.now(),
      sharedWithTherapist: sharedWithTherapist,
    );
  }

  /// Convert Journal → Map(String, dynamic) for Firestore
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "emotionId": emotionId,
      "description": description,
      "createdAt": createdAt.toIso8601String(),
      "sharedWithTherapist": sharedWithTherapist,
    };
  }

  /// Convert Firestore Map → Journal
  factory Journal.fromMap(String id, Map<String, dynamic> map) {
    return Journal(
      id: id,
      userId: map["userId"] ?? "",
      emotionId: map["emotionId"] ?? "",
      description: map["description"] ?? "",
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"])
          : DateTime.now(),
      sharedWithTherapist: map["sharedWithTherapist"] ?? false,
    );
  }
}
