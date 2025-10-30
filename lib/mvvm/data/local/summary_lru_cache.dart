import 'dart:collection';
import 'package:here4u/mvvm/data/local/local_database.dart';


class SummaryLRUCache {
  final int maxSize;
  final _cache = LinkedHashMap<String, LocalSummary>();

  SummaryLRUCache({this.maxSize = 5});

  void put(LocalSummary summary) {
    _cache.remove(summary.id);
    _cache[summary.id] = summary;

    if (_cache.length > maxSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
  }

  LocalSummary? get(String id) {
    final value = _cache.remove(id);
    if (value != null) {
      _cache[id] = value;
    }
    return value;
  }

  List<LocalSummary> get allSummaries => _cache.values.toList();

  LocalSummary? get latest => _cache.isNotEmpty ? _cache.values.last : null;

  bool contains(String id) => _cache.containsKey(id);

  void clear() => _cache.clear();

  int get size => _cache.length;
}
