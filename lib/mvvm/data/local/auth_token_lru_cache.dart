import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A small model representing a persisted auth token.
class AuthToken {
  final String id; // an identifier for the token (e.g., user id or generated id)
  final String token; // the token string (JWT or opaque token)
  final int issuedAtMillis; // when token was issued (ms since epoch)
  final int expiresAtMillis; // expiry time (ms since epoch)

  AuthToken({
    required this.id,
    required this.token,
    required this.issuedAtMillis,
    required this.expiresAtMillis,
  });

  bool get isExpired => DateTime.now().millisecondsSinceEpoch >= expiresAtMillis;

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'issuedAtMillis': issuedAtMillis,
        'expiresAtMillis': expiresAtMillis,
      };

  factory AuthToken.fromJson(Map<String, dynamic> j) => AuthToken(
        id: j['id'] as String,
        token: j['token'] as String,
        issuedAtMillis: (j['issuedAtMillis'] as num).toInt(),
        expiresAtMillis: (j['expiresAtMillis'] as num).toInt(),
      );
}

/// LRU cache for AuthToken objects with secure persistence using flutter_secure_storage.
///
/// Behavior:
/// - Keeps an in-memory LinkedHashMap acting as an LRU ordered map (oldest first).
/// - On put, moves token to most-recent; if over maxSize, removes the oldest.
/// - Persists the whole list to secure storage after mutations.
class AuthTokenLRUCache {
  final int maxSize;
  final FlutterSecureStorage _storage;
  final String _storageKey;
  final LinkedHashMap<String, AuthToken> _cache = LinkedHashMap();

  /// Create a cache. _storageKey defaults to 'auth_token_lru_cache'.
  AuthTokenLRUCache({
    this.maxSize = 5,
    FlutterSecureStorage? secureStorage,
    String storageKey = 'auth_token_lru_cache',
  })  : _storage = secureStorage ?? const FlutterSecureStorage(),
        _storageKey = storageKey;

  /// Initialize cache from secure storage. Call this during app startup or when needed.
  Future<void> loadFromStorage() async {
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw == null || raw.isEmpty) return;
      final List<dynamic> list = json.decode(raw) as List<dynamic>;
      _cache.clear();
      for (final item in list) {
        final Map<String, dynamic> m = Map<String, dynamic>.from(item as Map);
        final token = AuthToken.fromJson(m);
        _cache[token.id] = token;
      }
    } catch (e) {
      debugPrint('[AuthTokenLRUCache] Failed to load from storage: $e');
    }
  }

  /// Persist current in-memory cache (ordered oldest->newest) to secure storage.
  Future<void> persistToStorage() async {
    try {
      final list = _cache.values.map((t) => t.toJson()).toList();
      final raw = json.encode(list);
      await _storage.write(key: _storageKey, value: raw);
    } catch (e) {
      debugPrint('[AuthTokenLRUCache] Failed to persist to storage: $e');
    }
  }

  /// Put or update a token. Moves it to most-recent position.
  Future<void> put(AuthToken token) async {
    _cache.remove(token.id);
    _cache[token.id] = token;

    if (_cache.length > maxSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }

    await persistToStorage();
  }

  /// Get a token by id. Access will move it to most-recent.
  Future<AuthToken?> get(String id) async {
    final existing = _cache.remove(id);
    if (existing != null) {
      // move to end
      _cache[id] = existing;
      await persistToStorage();
    }
    return existing;
  }

  /// Remove a token by id.
  Future<void> remove(String id) async {
    _cache.remove(id);
    await persistToStorage();
  }

  /// Clear the cache and secure storage.
  Future<void> clear() async {
    _cache.clear();
    try {
      await _storage.delete(key: _storageKey);
    } catch (e) {
      debugPrint('[AuthTokenLRUCache] Failed to delete storage key: $e');
    }
  }

  /// Get all tokens (from oldest to newest).
  List<AuthToken> get allTokens => _cache.values.toList();

  /// Latest (most-recent) token or null.
  AuthToken? get latest => _cache.isNotEmpty ? _cache.values.last : null;

  /// Whether cache contains token id.
  bool contains(String id) => _cache.containsKey(id);

  /// The current size of the cache.
  int get size => _cache.length;

  /// Convenience: find the first non-expired token (most-recent first by reversing values).
  AuthToken? firstValidToken() {
    final values = _cache.values.toList().reversed; // newest first
    for (final t in values) {
      if (!t.isExpired) return t;
    }
    return null;
  }
}

// Note: LocalSummary import is intentionally included above to keep parity with other local files
// in this folder; if it's unused the analyzer may prompt to remove it. We prefer keeping the
// import consistent with file patterns in the project.
