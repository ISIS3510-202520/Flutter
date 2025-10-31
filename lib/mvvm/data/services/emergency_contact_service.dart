import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/data/local/local_database.dart';
import 'package:here4u/mvvm/data/local/emergency_contact_lru_cache.dart';

class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDatabase _localDb = LocalDatabase();
  final EmergencyContactLRUCache _cache = EmergencyContactLRUCache(maxSize: 20);

  /// Guarda un contacto en Firestore, Local DB y Cache.
  Future<void> saveContact(EmergencyContact contact) async {
    final localContact = LocalEmergencyContact(
      id: contact.id,
      userId: contact.userId,
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      relation: contact.relation,
    );

    try {
      // Intentamos guardar en Firestore
      final docRef =
          await _firestore.collection("EmergencyContact").add(contact.toMap());
      await docRef.update({"id": docRef.id});

      // Actualizamos local DB y cache
      final syncedContact = localContact.copyWith(id: docRef.id);
      await _localDb.upsertContact(syncedContact);
      _cache.put(syncedContact);

      print("✅ Contacto guardado y sincronizado correctamente.");
    } on SocketException {
      // 🌐 Sin internet → guarda solo local y cache
      print("⚠️ Sin conexión. Guardando contacto solo en local DB y caché.");
      await _localDb.upsertContact(localContact);
      _cache.put(localContact);
    } catch (e) {
      print("❌ Error guardando contacto: $e");
    }
  }

  /// Obtiene contactos del usuario.
  /// Estrategia jerárquica:
  /// 1. Cache (si ya están cargados)
  /// 2. Local DB (si no hay cache o sin internet)
  /// 3. Firebase (si hay conexión)
  /// Si no hay nada, retorna lista vacía.
  Future<List<EmergencyContact>> getContacts(String userId) async {
    try {
      // 🔹 1. Revisar cache primero
      if (_cache.size > 0) {
        print("⚡ Recuperando contactos desde caché en memoria");
        return _cache.allContacts
            .where((c) => c.userId == userId)
            .map((c) => EmergencyContact(
                  id: c.id,
                  userId: c.userId,
                  name: c.name,
                  phone: c.phone,
                  email: c.email,
                  relation: c.relation,
                ))
            .toList();
      }

      // 🔹 2. Intentar conexión con Firestore (si hay internet)
      final snapshot = await _firestore
          .collection("EmergencyContact")
          .where("userId", isEqualTo: userId)
          .get();

      // ✅ Si hay datos en Firestore → sincronizar con local y cache
      final rawData =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      final contacts =
          await compute(_parseContactsInIsolate, jsonEncode(rawData));

      // Limpiar y actualizar base local
      await _localDb.clearContactsForUser(userId);
      for (final c in contacts) {
        final localC = LocalEmergencyContact(
          id: c.id,
          userId: c.userId,
          name: c.name,
          phone: c.phone,
          email: c.email,
          relation: c.relation,
        );
        await _localDb.upsertContact(localC);
        _cache.put(localC);
      }

      print("✅ Contactos actualizados desde Firebase.");
      return contacts;
    } on SocketException {
      // 🔹 3. Sin conexión → revisar local storage
      print("⚠️ Sin conexión. Revisando cache y base local...");

      // Si hay algo en cache, devolverlo
      if (_cache.size > 0) {
        print("⚡ Devolviendo contactos desde caché (offline)");
        return _cache.allContacts
            .where((c) => c.userId == userId)
            .map((c) => EmergencyContact(
                  id: c.id,
                  userId: c.userId,
                  name: c.name,
                  phone: c.phone,
                  email: c.email,
                  relation: c.relation,
                ))
            .toList();
      }

      // Si no hay en cache, revisar DB local
      final localContacts = await _localDb.getContacts(userId);
      if (localContacts.isNotEmpty) {
        _cache.preload(localContacts);
        print("📦 Recuperando contactos desde base local (offline).");
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
      }

      // Si no hay nada en cache ni en local
      print("⚠️ Sin datos locales ni conexión. Retornando lista vacía.");
      return [];
    } catch (e) {
      print("❌ Error obteniendo contactos: $e");
      return [];
    }
  }
}

/// 🔧 Procesamiento en isolate (optimiza parsing JSON)
List<EmergencyContact> _parseContactsInIsolate(String rawJson) {
  final List<dynamic> decoded = jsonDecode(rawJson);
  return decoded
      .map((data) => EmergencyContact.fromMap(
          data['id'] as String, Map<String, dynamic>.from(data)))
      .toList();
}
