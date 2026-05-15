enum MemoryType { note, photo, audio, place, heart, goal }

class Memory {
  const Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.emotion,
    this.lockedUntil,
    this.photoPath,
    this.audioPath,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final MemoryType type;
  final String emotion;
  final DateTime? lockedUntil;
  final String? photoPath;
  final String? audioPath;

  bool get isCapsule => lockedUntil != null;
  bool get isUnlocked =>
      lockedUntil == null || !DateTime.now().isBefore(lockedUntil!);
  bool get hasPhoto => photoPath != null && photoPath!.isNotEmpty;
  bool get hasAudio => audioPath != null && audioPath!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type.name,
      'emotion': emotion,
      'lockedUntil': lockedUntil?.toIso8601String(),
      'photoPath': photoPath,
      'audioPath': audioPath,
    };
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id:
          json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Recuerdo sin titulo',
      description:
          json['description'] as String? ?? 'Un momento especial guardado.',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      type: memoryTypeFromName(json['type'] as String?),
      emotion: json['emotion'] as String? ?? 'Carino',
      lockedUntil: DateTime.tryParse(json['lockedUntil'] as String? ?? ''),
      photoPath: json['photoPath'] as String?,
      audioPath: json['audioPath'] as String?,
    );
  }
}

MemoryType memoryTypeFromName(String? name) {
  return MemoryType.values.firstWhere(
    (type) => type.name == name,
    orElse: () => MemoryType.note,
  );
}

List<Memory> starterMemories() {
  return [
    Memory(
      id: 'starter-note',
      title: 'Primera promesa',
      description:
          'Una nota pequena para recordar que este arbol empieza con ustedes.',
      date: DateTime(2026, 1, 1),
      type: MemoryType.note,
      emotion: 'Ternura',
    ),
    Memory(
      id: 'starter-photo',
      title: 'Foto favorita',
      description:
          'Toca el icono de foto al crear un recuerdo para elegir una imagen.',
      date: DateTime(2026, 5, 6),
      type: MemoryType.photo,
      emotion: 'Alegria',
    ),
    Memory(
      id: 'starter-audio',
      title: 'Nota de voz',
      description: 'Elige Audio para grabar una voz y colgarla como esfera.',
      date: DateTime(2026, 5, 6),
      type: MemoryType.audio,
      emotion: 'Cercania',
    ),
    Memory(
      id: 'starter-capsule',
      title: 'Abrir en Navidad',
      description: 'Capsula bloqueada hasta que llegue diciembre.',
      date: DateTime(2026, 5, 6),
      type: MemoryType.heart,
      emotion: 'Misterio',
      lockedUntil: DateTime(2026, 12, 24),
    ),
  ];
}
