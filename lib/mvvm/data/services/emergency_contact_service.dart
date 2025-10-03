import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here4u/models/emergency_contact.dart';


class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveContact(EmergencyContact contact) async {
    final docRef = await _firestore
        .collection("EmergencyContact")
        .add(contact.toMap());

    await docRef.update({"id": docRef.id});
  }


}