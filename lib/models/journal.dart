import 'package:uuid/uuid.dart';

class Journal {
  final String id;
  final String userId;
  final String emotionId;
  final String description;
  final DateTime createdAt;
  final bool sharedWithTherapist;

  Journal({
    required this.id,
    required this.userId,
    required this.emotionId,
    required this.description,
    required this.createdAt,
    this.sharedWithTherapist = false,
  });

  factory Journal.create({
    required String userId,
    required String emotionId,
    required String description,
  }) {
    return Journal(
      id: const Uuid().v4(),
      userId: userId,
      emotionId: emotionId,
      description: description,
      createdAt: DateTime.now(),
    );
  }
}
