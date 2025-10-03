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
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastLogin: (json['lastLogin'] as Timestamp).toDate(),
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastEntryDate: (json['lastEntryDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastEntryDate': lastEntryDate,
    };
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastEntryDate,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastEntryDate: lastEntryDate ?? this.lastEntryDate,
    );
  }
}