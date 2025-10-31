import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // <- necesario para usar compute
import 'package:here4u/models/emergency_contact.dart';

class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveContact(EmergencyContact contact) async {
    final docRef = await _firestore
        .collection("EmergencyContact")
        .add(contact.toMap());

    await docRef.update({"id": docRef.id});
  }

  Future<List<EmergencyContact>> getContacts(String userId) async {
    final snapshot = await _firestore
        .collection("EmergencyContact")
        .where("userId", isEqualTo: userId)
        .get();

    
    final rawData = snapshot.docs // docs en json porque es más liviano
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    return await compute(_parseContactsInIsolate, jsonEncode(rawData));  // Isolando
  }
}

/// Isolates
List<EmergencyContact> _parseContactsInIsolate(String rawJson) {
  final List<dynamic> decoded = jsonDecode(rawJson);

  return decoded
      .map((data) =>
          EmergencyContact.fromMap(data['id'] as String, Map<String, dynamic>.from(data)))
      .toList();
}
