import 'package:shared_preferences/shared_preferences.dart';

/// Guarda cuándo fue la última vez que el usuario abrió la app.
class VisitStore {
  static const _key = 'last_open_iso';

  /// Devuelve la visita anterior (null en el primer uso) y registra "ahora"
  /// como la última visita.
  Future<DateTime?> recordVisitAndGetPrevious() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final previous = raw == null ? null : DateTime.tryParse(raw);
    await prefs.setString(_key, DateTime.now().toIso8601String());
    return previous;
  }
}
