import 'dart:collection';
import 'package:here4u/mvvm/data/local/local_database.dart';

/// LRU Cache para contactos de emergencia.
/// Guarda en memoria los contactos más recientes accedidos o actualizados.
/// Ideal para mejorar rendimiento y evitar consultas repetidas a la base local.
class EmergencyContactLRUCache {
  final int maxSize;
  final _cache = LinkedHashMap<String, LocalEmergencyContact>();

  EmergencyContactLRUCache({this.maxSize = 20});

  /// Inserta o actualiza un contacto en el caché
  void put(LocalEmergencyContact contact) {
    // Si ya existe, lo eliminamos para moverlo al final (más reciente)
    _cache.remove(contact.id);
    _cache[contact.id] = contact;

    // Si se excede el tamaño máximo, eliminamos el más antiguo
    if (_cache.length > maxSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
  }

  /// Recupera un contacto del caché
  LocalEmergencyContact? get(String id) {
    final value = _cache.remove(id);
    if (value != null) {
      // Lo volvemos a insertar al final para marcarlo como más recientemente usado
      _cache[id] = value;
    }
    return value;
  }

  /// Retorna todos los contactos actualmente almacenados
  List<LocalEmergencyContact> get allContacts => _cache.values.toList();

  /// Retorna el último contacto accedido
  LocalEmergencyContact? get latest =>
      _cache.isNotEmpty ? _cache.values.last : null;

  /// Verifica si un contacto está en caché
  bool contains(String id) => _cache.containsKey(id);

  /// Limpia el caché completamente
  void clear() => _cache.clear();

  /// Retorna el número de elementos en caché
  int get size => _cache.length;

  /// Inserta una lista completa (por ejemplo, al sincronizar desde DB local)
  void preload(List<LocalEmergencyContact> contacts) {
    for (final contact in contacts) {
      put(contact);
    }
  }
}
