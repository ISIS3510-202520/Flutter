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
    try {
      print("💾 Guardando contacto ${contact.name}...");

      // 🔹 Primero guardamos local y cache para que sea visible inmediatamente
      final tempLocal = LocalEmergencyContact(
        id: contact.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        email: contact.email,
        relation: contact.relation,
      );
      await _localDb.upsertContact(tempLocal);
      _cache.put(tempLocal);

      // 🌐 Intentamos guardar en Firebase
      final docRef =
          await _firestore.collection("EmergencyContact").add(contact.toMap());
      await docRef.update({"id": docRef.id});

      // 🔹 Actualizamos el ID real en local y cache (para mantener sincronía)
      final syncedContact = tempLocal.copyWith(id: docRef.id);
      await _localDb.upsertContact(syncedContact);
      _cache.put(syncedContact);

      print("✅ Contacto guardado y sincronizado correctamente con Firebase.");
    } on SocketException {
      print("⚠️ Sin conexión. Guardando solo en local y caché.");
      final localContact = LocalEmergencyContact(
        id: contact.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        email: contact.email,
        relation: contact.relation,
      );
      await _localDb.upsertContact(localContact);
      _cache.put(localContact);
    } catch (e) {
      print("❌ Error guardando contacto: $e");
    }
  }

  /// Obtiene contactos del usuario.
  Future<List<EmergencyContact>> getContacts(String userId) async {
    try {
      print("🌐 Intentando obtener contactos desde Firebase...");
      final snapshot = await _firestore
          .collection("EmergencyContact")
          .where("userId", isEqualTo: userId)
          .get();

      final rawData =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      final contacts =
          await compute(_parseContactsInIsolate, jsonEncode(rawData));

      // ✅ Sincronizamos local y cache con los datos más nuevos
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

      print("✅ Contactos actualizados y sincronizados desde Firebase.");
      return contacts;
    } on SocketException {
      print("⚠️ Sin conexión. Revisando caché...");
      if (_cache.size > 0) {
        print("⚡ Devolviendo contactos desde caché (offline).");
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

      print("📦 No hay caché. Revisando base local...");
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

      print("⚠️ Sin datos en Firebase, caché ni local. Retornando vacío.");
      return [];
    } catch (e) {
      print("❌ Error obteniendo contactos: $e");
      return [];
    }
  }

  /// Elimina un contacto de Firestore, Local DB y Cache.
  Future<void> deleteContact(EmergencyContact contact) async {
    try {
      print("🗑️ Eliminando contacto ${contact.name}...");

      // 🌐 Intentamos eliminar de Firebase
      final query = await _firestore
          .collection("EmergencyContact")
          .where("id", isEqualTo: contact.id)
          .get();

      for (final doc in query.docs) {
        await doc.reference.delete();
      }

      // 🔹 Eliminamos de local y cache
      await _localDb.deleteContact(contact.id);
      _cache.allContacts.removeWhere((c) => c.id == contact.id);

      print("✅ Contacto eliminado correctamente de Firebase, local y caché.");
    } on SocketException {
      print("⚠️ Sin conexión. No se puede eliminar de Firebase ahora.");
    } catch (e) {
      print("❌ Error eliminando contacto: $e");
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
