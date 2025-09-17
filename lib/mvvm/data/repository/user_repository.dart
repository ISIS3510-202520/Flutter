import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here4u/models/user_entity.dart';

class UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserEntity user) async {
    await _users.doc(user.id).set(user.toJson());
  }

  Future<UserEntity?> getUser(String id) async {
    final doc = await _users.doc(id).get();
    if (doc.exists) {
      return UserEntity.fromJson(doc.data()!);
    }
    return null;
  }
  // Add update, delete, and stream methods as needed
}