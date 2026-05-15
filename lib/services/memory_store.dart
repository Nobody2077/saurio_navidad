import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/memory.dart';

class MemoryStore {
  static const _key = 'saurio_memories';

  Future<List<Memory>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key);
    if (encoded == null || encoded.isEmpty) {
      return starterMemories();
    }

    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      return starterMemories();
    }

    return decoded
        .whereType<Map>()
        .map((item) => Memory.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> save(List<Memory> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      memories.map((memory) => memory.toJson()).toList(),
    );
    await prefs.setString(_key, encoded);
  }
}
