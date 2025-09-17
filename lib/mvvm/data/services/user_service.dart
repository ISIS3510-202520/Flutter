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
      // Check if user already exists with this email in Firestore
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
      await credential.user?.updateDisplayName(name);

      // Create UserEntity and push to Firestore
      final userEntity = UserEntity(
        id: credential.user!.uid,
        name: name,
        email: email,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(userEntity.toJson());

      // Send email verification
      await credential.user?.sendEmailVerification();

      return credential.user;
    } catch (e) {
      return null;
    }
  }
}