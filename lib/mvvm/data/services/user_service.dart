import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_entity.dart';
class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> registerWithEmail(String email, String password, String name) async {
    try {
      final existing = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (existing.docs.isNotEmpty) {
        return null;
      }
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final userEntity = UserEntity(
          id: user.uid,
          name: name,
          email: email,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userEntity.toJson());
        await user.sendEmailVerification();
        await user.updateDisplayName(name);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}