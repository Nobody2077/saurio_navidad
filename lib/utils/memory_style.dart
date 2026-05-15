import 'package:flutter/material.dart';

import '../models/memory.dart';

IconData typeIcon(MemoryType type) {
  switch (type) {
    case MemoryType.note:
      return Icons.notes;
    case MemoryType.photo:
      return Icons.photo_camera_outlined;
    case MemoryType.audio:
      return Icons.mic_none;
    case MemoryType.place:
      return Icons.place_outlined;
    case MemoryType.heart:
      return Icons.favorite_border;
    case MemoryType.goal:
      return Icons.star_border;
  }
}

Color typeColor(MemoryType type) {
  switch (type) {
    case MemoryType.note:
      return const Color(0xFF9D7BEA);
    case MemoryType.photo:
      return const Color(0xFF5DADE2);
    case MemoryType.audio:
      return const Color(0xFF4CC58A);
    case MemoryType.place:
      return const Color(0xFFE29F5D);
    case MemoryType.heart:
      return const Color(0xFFE86F68);
    case MemoryType.goal:
      return const Color(0xFFE0C073);
  }
}

String typeLabel(MemoryType type) {
  switch (type) {
    case MemoryType.note:
      return 'Nota';
    case MemoryType.photo:
      return 'Foto';
    case MemoryType.audio:
      return 'Audio';
    case MemoryType.place:
      return 'Lugar';
    case MemoryType.heart:
      return 'Momento';
    case MemoryType.goal:
      return 'Meta';
  }
}
