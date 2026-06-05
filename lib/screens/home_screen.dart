import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/memory.dart';
import '../painters/saurio_painter.dart';
import '../painters/snow_painter.dart';
import '../painters/tree_painter.dart';
import '../services/memory_store.dart';
import '../utils/memory_style.dart';
import '../widgets/add_memory_form.dart';
import '../widgets/capsule_chest_sheet.dart';
import '../widgets/daily_question.dart';
import '../widgets/december_calendar.dart';
import '../widgets/gift_chest.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_detail.dart';
import '../widgets/memory_list.dart';
import '../widgets/notification_settings_sheet.dart';
import '../widgets/saurio_companion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final MemoryStore _store = MemoryStore();

  List<Memory> _memories = [];
  bool _loading = true;
  SaurioMood? _saurioMoodOverride;
  String? _saurioMessageOverride;
  Memory? _newSphereMemory;
  int _reactionToken = 0;
  int _sphereFlightToken = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _loadMemories();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDecember => DateTime.now().month == 12;

  List<Memory> get _visibleMemories {
    final now = DateTime.now();
    if (!_isDecember) {
      return _memories.where((memory) => !memory.isCapsule).toList();
    }
    return _memories
        .where((memory) => memory.date.day <= now.day && memory.isUnlocked)
        .toList();
  }

  List<Memory> get _capsules =>
      _memories.where((memory) => memory.isCapsule).toList();

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final isMorning = hour >= 5 && hour < 11;
    final visibleMemories = _visibleMemories;
    final saurioMood = _saurioMoodOverride ?? SaurioMood.cozy;
    final saurioMessage = _saurioMessageOverride ?? _ambientSaurioMessage(hour);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isMorning
                    ? const [
                        Color(0xFF263D57),
                        Color(0xFF8B6F6B),
                        Color(0xFF171B24),
                      ]
                    : const [
                        Color(0xFF080B13),
                        Color(0xFF182334),
                        Color(0xFF11151D),
                      ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SnowField(
                      progress: _controller.value,
                      morning: isMorning,
                    ),
                  ),
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 96),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              HomeHeader(
                                isDecember: _isDecember,
                                memories: _memories.length,
                                onNotificationSettings:
                                    _openNotificationSettings,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 560,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    // Tree rendered first so Saurio appears in front
                                    Positioned(
                                      bottom: 72,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _showMemorySheet(visibleMemories),
                                        child: ChristmasTreeView(
                                          progress: _controller.value,
                                          memories: visibleMemories,
                                          lit: _isDecember,
                                        ),
                                      ),
                                    ),
                                    if (_newSphereMemory != null)
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: _NewSphereFlight(
                                            key: ValueKey(_sphereFlightToken),
                                            memory: _newSphereMemory!,
                                          ),
                                        ),
                                      ),
                                    // Saurio at bottom-left, in front of tree
                                    Positioned(
                                      bottom: 98,
                                      left: 2,
                                      child: SaurioCompanion(
                                        mood: saurioMood,
                                        message: saurioMessage,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: _showCapsuleChest,
                                        child: GiftChest(
                                          capsules: _capsules.length,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              DailyQuestion(onAdd: _openAddMemory),
                              const SizedBox(height: 14),
                              DecemberCalendar(
                                isDecember: _isDecember,
                                memories: _memories,
                              ),
                              const SizedBox(height: 14),
                              MemoryList(
                                memories: visibleMemories,
                                onTap: _openMemory,
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddMemory,
        backgroundColor: const Color(0xFFE0C073),
        foregroundColor: const Color(0xFF17130A),
        icon: const Icon(Icons.add),
        label: const Text('Recuerdo'),
      ),
    );
  }

  Future<void> _loadMemories() async {
    final memories = await _store.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _memories = memories;
      _loading = false;
    });
  }

  void _openMemory(Memory memory) {
    _reactForMemory(memory);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171B24),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) =>
          MemoryDetail(memory: memory, onDelete: _deleteMemory),
    );
  }

  void _showMemorySheet(List<Memory> memories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171B24),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .72,
          minChildSize: .35,
          maxChildSize: .9,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                MemoryList(
                  memories: memories,
                  onTap: _openMemory,
                  compact: false,
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171B24),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const NotificationSettingsSheet(),
    );
  }

  void _showCapsuleChest() {
    _setSaurioReaction(
      mood: SaurioMood.surprise,
      message:
          'El cofre guarda cosas con paciencia. Abrirlo siempre debe sentirse especial.',
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171B24),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .68,
          minChildSize: .35,
          maxChildSize: .9,
          builder: (context, _) {
            return CapsuleChestSheet(memories: _capsules, onTap: _openMemory);
          },
        );
      },
    );
  }

  Future<void> _deleteMemory(Memory memory) async {
    final updated = _memories
        .where((storedMemory) => storedMemory.id != memory.id)
        .toList();

    HapticFeedback.mediumImpact();
    setState(() => _memories = updated);
    await _store.save(updated);
    await _deleteMemoryFile(memory.photoPath);
    await _deleteMemoryFile(memory.audioPath);

    _setSaurioReaction(
      mood: SaurioMood.cozy,
      message: 'Listo, esa esfera ya no esta en el arbol.',
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Esfera borrada.')));
  }

  Future<void> _deleteMemoryFile(String? path) async {
    if (path == null || path.isEmpty) {
      return;
    }
    final file = File(path);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } on FileSystemException {
      // The memory is already removed from the app even if the old media file
      // cannot be deleted from disk.
    }
  }

  void _openAddMemory() {
    _setSaurioReaction(
      mood: SaurioMood.excited,
      message:
          'Vamos a colgar una esfera nueva. Puede ser pequena y aun asi valer mucho.',
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171B24),
      showDragHandle: true,
      builder: (context) {
        return AddMemoryForm(
          onTypeChanged: _reactForSelectedType,
          onRecordingChanged: (recording) {
            _setSaurioReaction(
              mood: recording ? SaurioMood.recording : SaurioMood.excited,
              message: recording
                  ? 'Estoy escuchando suavecito. Graba con calma.'
                  : 'Audio guardado. Esa esfera ya tiene voz.',
            );
          },
          onSave: (memory) async {
            final updated = [memory, ..._memories];
            HapticFeedback.lightImpact();
            SystemSound.play(SystemSoundType.click);
            setState(() {
              _memories = updated;
              _newSphereMemory = memory;
              _sphereFlightToken++;
            });
            await _store.save(updated);
            _reactForMemory(memory, saved: true);
            Future.delayed(const Duration(milliseconds: 950), () {
              if (!mounted) {
                return;
              }
              setState(() => _newSphereMemory = null);
            });
            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  String _ambientSaurioMessage(int hour) {
    if (hour >= 5 && hour < 11) {
      return 'Buenos dias. El arbol ya esta despierto y yo tambien.';
    }
    if (hour >= 11 && hour < 18) {
      return 'Que bueno verte por aqui. Hoy el arbol esta tranquilo y brillante.';
    }
    return 'Llegaste en modo noche. Las luces se ven mejor asi.';
  }

  void _reactForMemory(Memory memory, {bool saved = false}) {
    final prefix = saved
        ? 'Listo, esfera guardada.'
        : 'Esta esfera tiene algo especial.';
    switch (memory.type) {
      case MemoryType.photo:
        _setSaurioReaction(
          mood: SaurioMood.photo,
          message: '$prefix Me quedo quietito para la foto.',
        );
        break;
      case MemoryType.audio:
        _setSaurioReaction(
          mood: SaurioMood.recording,
          message: '$prefix Las voces hacen que el arbol suene vivo.',
        );
        break;
      case MemoryType.heart:
        _setSaurioReaction(
          mood: SaurioMood.surprise,
          message: '$prefix Esta tiene brillo de secreto.',
        );
        break;
      case MemoryType.place:
        _setSaurioReaction(
          mood: SaurioMood.excited,
          message: '$prefix Un lugar tambien puede ser una casa pequena.',
        );
        break;
      case MemoryType.goal:
        _setSaurioReaction(
          mood: SaurioMood.excited,
          message: '$prefix Las metas quedan lindas cerca de la estrella.',
        );
        break;
      case MemoryType.note:
        _setSaurioReaction(
          mood: SaurioMood.excited,
          message: '$prefix Una nota suave para el arbol.',
        );
        break;
    }
  }

  void _reactForSelectedType(MemoryType type) {
    switch (type) {
      case MemoryType.photo:
        _setSaurioReaction(
          mood: SaurioMood.photo,
          message: 'Foto elegida. Yo pongo mi mejor cara de dino.',
        );
        break;
      case MemoryType.audio:
        _setSaurioReaction(
          mood: SaurioMood.recording,
          message: 'Audio elegido. Puedo quedarme quietito mientras grabas.',
        );
        break;
      case MemoryType.heart:
        _setSaurioReaction(
          mood: SaurioMood.surprise,
          message: 'Los momentos de corazon van con brillo extra.',
        );
        break;
      case MemoryType.place:
        _setSaurioReaction(
          mood: SaurioMood.excited,
          message: 'Un lugar puede vivir dentro del arbol tambien.',
        );
        break;
      case MemoryType.goal:
        _setSaurioReaction(
          mood: SaurioMood.excited,
          message: 'Una meta cerca de la estrella. Tiene sentido.',
        );
        break;
      case MemoryType.note:
        _setSaurioReaction(
          mood: SaurioMood.cozy,
          message: 'Nota elegida. A veces una frase alcanza.',
        );
        break;
    }
  }

  void _setSaurioReaction({required SaurioMood mood, required String message}) {
    final token = ++_reactionToken;
    setState(() {
      _saurioMoodOverride = mood;
      _saurioMessageOverride = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted || token != _reactionToken) {
        return;
      }
      setState(() {
        _saurioMoodOverride = null;
        _saurioMessageOverride = null;
      });
    });
  }
}

class _NewSphereFlight extends StatelessWidget {
  const _NewSphereFlight({super.key, required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final bottom = 34 + value * 258;
        final sideShift = (value - .5) * 82;
        return Stack(
          children: [
            Positioned(
              bottom: bottom,
              left: MediaQuery.sizeOf(context).width / 2 - 14 + sideShift,
              child: Opacity(
                opacity: (1 - value * .15).clamp(0, 1),
                child: Transform.scale(scale: 1 + value * .28, child: child),
              ),
            ),
          ],
        );
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: typeColor(memory.type),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: typeColor(memory.type).withValues(alpha: .65),
              blurRadius: 18,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Icon(typeIcon(memory.type), color: Colors.white, size: 16),
      ),
    );
  }
}
