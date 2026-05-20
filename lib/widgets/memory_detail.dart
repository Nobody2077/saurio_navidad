import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/date_helpers.dart';
import '../utils/memory_style.dart';
import 'pill.dart';

class MemoryDetail extends StatelessWidget {
  const MemoryDetail({super.key, required this.memory, required this.onDelete});

  final Memory memory;
  final Future<void> Function(Memory memory) onDelete;

  @override
  Widget build(BuildContext context) {
    final photoPath = memory.photoPath;
    final audioPath = memory.audioPath;
    final hasPhoto = photoPath != null && File(photoPath).existsSync();
    final hasAudio = audioPath != null && File(audioPath).existsSync();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: typeColor(memory.type),
                child: Icon(typeIcon(memory.type)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  memory.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Borrar esfera',
              ),
            ],
          ),
          if (hasPhoto) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(photoPath),
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
            ),
          ],
          if (hasAudio) ...[
            const SizedBox(height: 16),
            AudioPlayerPanel(audioPath: audioPath),
          ],
          const SizedBox(height: 16),
          Text(
            memory.description,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(icon: Icons.favorite_border, label: memory.emotion),
              Pill(icon: typeIcon(memory.type), label: typeLabel(memory.type)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Fecha: ${shortDate(memory.date)}',
            style: const TextStyle(color: Color(0xFFC9D3CC)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Borrar esfera'),
          content: Text('Quieres borrar "${memory.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Borrar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await onDelete(memory);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class AudioPlayerPanel extends StatefulWidget {
  const AudioPlayerPanel({super.key, required this.audioPath});

  final String audioPath;

  @override
  State<AudioPlayerPanel> createState() => _AudioPlayerPanelState();
}

class _AudioPlayerPanelState extends State<AudioPlayerPanel> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _playing = false);
      }
    });
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x334CC58A)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF4CC58A),
            child: Icon(_playing ? Icons.graphic_eq : Icons.mic_none),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Nota de voz guardada',
              style: TextStyle(color: Color(0xFFD6D2C8)),
            ),
          ),
          IconButton.filledTonal(
            onPressed: _toggle,
            icon: Icon(_playing ? Icons.stop : Icons.play_arrow),
            tooltip: _playing ? 'Detener audio' : 'Reproducir audio',
          ),
        ],
      ),
    );
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.stop();
      if (mounted) {
        setState(() => _playing = false);
      }
      return;
    }

    await _player.play(DeviceFileSource(widget.audioPath));
    if (mounted) {
      setState(() => _playing = true);
    }
  }
}
