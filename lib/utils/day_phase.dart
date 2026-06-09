import 'package:flutter/material.dart';

/// Momento del día que define la atmósfera de la escena.
enum DayPhase { morning, midday, night }

DayPhase dayPhaseForHour(int hour) {
  if (hour >= 5 && hour < 12) return DayPhase.morning;
  if (hour >= 12 && hour < 18) return DayPhase.midday;
  return DayPhase.night;
}

extension DayPhasePalette on DayPhase {
  /// Colores del degradado del cielo (de arriba hacia abajo).
  List<Color> get skyColors {
    switch (this) {
      case DayPhase.morning:
        return const [Color(0xFF263D57), Color(0xFF8B6F6B), Color(0xFF171B24)];
      case DayPhase.midday:
        return const [Color(0xFF2E5A82), Color(0xFF6E97B8), Color(0xFFAFC4CE)];
      case DayPhase.night:
        return const [Color(0xFF080B13), Color(0xFF182334), Color(0xFF11151D)];
    }
  }

  /// Opacidad de los copos de nieve (de noche se ve más).
  double get snowOpacity {
    switch (this) {
      case DayPhase.morning:
        return .42;
      case DayPhase.midday:
        return .30;
      case DayPhase.night:
        return .62;
    }
  }

  /// Cantidad de copos.
  int get snowCount {
    switch (this) {
      case DayPhase.morning:
        return 70;
      case DayPhase.midday:
        return 55;
      case DayPhase.night:
        return 82;
    }
  }

  bool get showSun => this != DayPhase.night;

  /// Color del halo del sol (transparente de noche).
  Color get sunGlow {
    switch (this) {
      case DayPhase.morning:
        return const Color(0x55FFD99A);
      case DayPhase.midday:
        return const Color(0x66FFF1C8);
      case DayPhase.night:
        return const Color(0x00000000);
    }
  }

  /// Color de las nubes del saludo/chips (claro en todo momento para que el
  /// texto oscuro siempre se lea; atenuado de noche para no encandilar).
  Color get cloudColor {
    switch (this) {
      case DayPhase.morning:
        return const Color(0xFFFBF4EA);
      case DayPhase.midday:
        return const Color(0xFFF5F9FC);
      case DayPhase.night:
        return const Color(0xFFC9D2E2);
    }
  }

  /// Suelo nevado: [borde/brillo superior, cuerpo].
  List<Color> get groundColors {
    switch (this) {
      case DayPhase.morning:
        return const [Color(0xFFCBC6CE), Color(0xFF8E8A9A)];
      case DayPhase.midday:
        return const [Color(0xFFEAF1F7), Color(0xFFB9C9D8)];
      case DayPhase.night:
        return const [Color(0xFF3A4866), Color(0xFF222D44)];
    }
  }
}
