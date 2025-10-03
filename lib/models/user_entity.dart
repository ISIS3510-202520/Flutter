import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastEntryDate;

  UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.lastLogin,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastEntryDate,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastLogin: (json['lastLogin'] as Timestamp).toDate(),
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      lastEntryDate: (json['lastEntryDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastEntryDate': Timestamp.fromDate(lastEntryDate),
    };
  }
}