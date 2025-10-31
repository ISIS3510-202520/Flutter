import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/data/local/local_database.dart';

class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDatabase _localDb = LocalDatabase();

  /// Guarda un contacto tanto en Firestore como en la base local
  Future<void> saveContact(EmergencyContact contact) async {
    try {
      // Intentamos guardar en Firestore
      final docRef =
          await _firestore.collection("EmergencyContact").add(contact.toMap());
      await docRef.update({"id": docRef.id});

      // Si Firestore funciona, actualizamos también la DB local
      final localContact = LocalEmergencyContact(
        id: docRef.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        email: contact.email,
        relation: contact.relation,
      );
      await _localDb.upsertContact(localContact);
    } on SocketException {
      // Sin internet → guarda solo localmente
      final localContact = LocalEmergencyContact(
        id: contact.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        email: contact.email,
        relation: contact.relation,
      );
      await _localDb.upsertContact(localContact);
    } catch (e) {
      print("❌ Error guardando contacto: $e");
    }
  }

  /// Obtiene contactos del usuario.
  /// Si hay internet, sincroniza los datos de Firestore con la base local.
  /// Si no hay conexión, lee los datos de la base local.
  Future<List<EmergencyContact>> getContacts(String userId) async {
    try {
      // Intentar conexión a Firestore
      final snapshot = await _firestore
          .collection("EmergencyContact")
          .where("userId", isEqualTo: userId)
          .get();

      final rawData = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Parsear en isolate
      final contacts =
          await compute(_parseContactsInIsolate, jsonEncode(rawData));

      // ✅ Sincronizar localmente (borrar viejos y guardar nuevos)
      await _localDb.clearContactsForUser(userId);
      for (final c in contacts) {
        await _localDb.upsertContact(LocalEmergencyContact(
          id: c.id,
          userId: c.userId,
          name: c.name,
          phone: c.phone,
          email: c.email,
          relation: c.relation,
        ));
      }

      return contacts;
    } on SocketException {
      // 🌐 No hay internet: usar base local
      print("⚠️ Sin conexión. Recuperando contactos locales.");
      final localContacts = await _localDb.getContacts(userId);
      return localContacts
          .map((lc) => EmergencyContact(
                id: lc.id,
                userId: lc.userId,
                name: lc.name,
                phone: lc.phone,
                email: lc.email,
                relation: lc.relation,
              ))
          .toList();
    } catch (e) {
      print("❌ Error obteniendo contactos: $e");
      return [];
    }
  }
}

/// Función auxiliar para procesar contactos en un isolate
List<EmergencyContact> _parseContactsInIsolate(String rawJson) {
  final List<dynamic> decoded = jsonDecode(rawJson);
  return decoded
      .map((data) => EmergencyContact.fromMap(
          data['id'] as String, Map<String, dynamic>.from(data)))
      .toList();
}
