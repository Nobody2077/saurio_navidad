import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../services/audio_service.dart';
import '../services/photo_service.dart';
import '../utils/date_helpers.dart';
import '../utils/memory_style.dart';


class AddMemoryForm extends StatefulWidget {
  const AddMemoryForm({
    super.key,
    required this.onSave,
    this.onTypeChanged,
    this.onRecordingChanged,
  });

  final Future<void> Function(Memory memory) onSave;
  final ValueChanged<MemoryType>? onTypeChanged;
  final ValueChanged<bool>? onRecordingChanged;

  @override
  State<AddMemoryForm> createState() => _AddMemoryFormState();
}

class _AddMemoryFormState extends State<AddMemoryForm> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _photoService = PhotoService();
  final _audioService = AudioMemoryService();
  MemoryType _type = MemoryType.note;
  bool _capsule = false;
  bool _pickingPhoto = false;
  bool _recordingAudio = false;
  String? _photoPath;
  String? _audioPath;
  String? _emotion;

  @override
  void dispose() {
    if (_recordingAudio) {
      unawaited(_audioService.cancelRecording());
    }
    unawaited(_audioService.dispose());
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nueva esfera',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Titulo'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Descripcion'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _creatableTypes.map((type) {
              return ChoiceChip(
                selected: _type == type,
                avatar: Icon(typeIcon(type), size: 18),
                label: Text(typeLabel(type)),
                onSelected: (_) => _selectType(type),
              );
            }).toList(),
          ),
          if (_type == MemoryType.photo) ...[
            const SizedBox(height: 12),
            _PhotoPickerPreview(
              photoPath: _photoPath,
              picking: _pickingPhoto,
              onPick: _pickPhoto,
            ),
          ],
          if (_type == MemoryType.audio) ...[
            const SizedBox(height: 12),
            _AudioRecorderPreview(
              audioPath: _audioPath,
              recording: _recordingAudio,
              onStart: _startAudio,
              onStop: _stopAudio,
              onDelete: _deleteAudio,
            ),
          ],
          const SizedBox(height: 14),
          _EmotionPicker(
            selected: _emotion,
            onSelect: (value) => setState(() => _emotion = value),
          ),
          const SizedBox(height: 4),
          SwitchListTile(
            value: _capsule,
            contentPadding: EdgeInsets.zero,
            title: const Text('Guardar en cofre hasta Navidad'),
            onChanged: (value) => setState(() => _capsule = value),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Guardar esfera'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectType(MemoryType type) {
    setState(() => _type = type);
    widget.onTypeChanged?.call(type);
    if (type == MemoryType.photo && _photoPath == null) {
      _pickPhoto();
    }
  }

  Future<void> _pickPhoto() async {
    setState(() => _pickingPhoto = true);
    try {
      final path = await _photoService.pickAndSavePhoto();
      if (!mounted) {
        return;
      }
      if (path != null) {
        setState(() => _photoPath = path);
      }
    } finally {
      if (mounted) {
        setState(() => _pickingPhoto = false);
      }
    }
  }

  Future<void> _save() async {
    final now = DateTime.now();
    await widget.onSave(
      Memory(
        id: now.microsecondsSinceEpoch.toString(),
        title: _title.text.trim().isEmpty
            ? 'Recuerdo sin titulo'
            : _title.text.trim(),
        description: _description.text.trim().isEmpty
            ? 'Un momento especial guardado en el arbol.'
            : _description.text.trim(),
        date: now,
        type: _type,
        emotion: _emotion ?? (_capsule ? 'Sorpresa' : 'Cariño'),
        lockedUntil: _capsule ? nextChristmasEve(now) : null,
        photoPath: _type == MemoryType.photo ? _photoPath : null,
        audioPath: _type == MemoryType.audio ? _audioPath : null,
      ),
    );
  }

  Future<void> _startAudio() async {
    final path = await _audioService.startRecording();
    if (!mounted) {
      return;
    }
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activa el permiso de microfono.')),
      );
      return;
    }
    setState(() {
      _audioPath = path;
      _recordingAudio = true;
    });
    widget.onRecordingChanged?.call(true);
  }

  Future<void> _stopAudio() async {
    final path = await _audioService.stopRecording();
    if (!mounted) {
      return;
    }
    setState(() {
      _audioPath = path ?? _audioPath;
      _recordingAudio = false;
    });
    widget.onRecordingChanged?.call(false);
  }

  Future<void> _deleteAudio() async {
    if (_recordingAudio) {
      await _audioService.cancelRecording();
    }
    final path = _audioPath;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _audioPath = null;
      _recordingAudio = false;
    });
    widget.onRecordingChanged?.call(false);
  }
}

const _creatableTypes = [
  MemoryType.note,
  MemoryType.photo,
  MemoryType.audio,
  MemoryType.heart,
  MemoryType.goal,
];

class _EmotionPicker extends StatelessWidget {
  const _EmotionPicker({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              '¿Cómo se siente?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 6),
            Text(
              'opcional',
              style: TextStyle(fontSize: 11, color: Color(0xFF8A9A8A)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kEmotionOptions.map((opt) {
            final isSelected = selected == opt.label;
            return FilterChip(
              selected: isSelected,
              label: Text('${opt.emoji} ${opt.label}'),
              onSelected: (_) => onSelect(isSelected ? null : opt.label),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PhotoPickerPreview extends StatelessWidget {
  const _PhotoPickerPreview({
    required this.photoPath,
    required this.picking,
    required this.onPick,
  });

  final String? photoPath;
  final bool picking;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final hasPhoto = path != null && File(path).existsSync();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 74,
              height: 74,
              color: const Color(0x22000000),
              child: hasPhoto
                  ? Image.file(File(path), fit: BoxFit.cover)
                  : const Icon(Icons.photo_library_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasPhoto
                  ? 'Foto lista para guardar.'
                  : 'Elige una foto para esta esfera.',
              style: const TextStyle(color: Color(0xFFD6D2C8)),
            ),
          ),
          IconButton.filledTonal(
            onPressed: picking ? null : onPick,
            icon: picking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image_search_outlined),
            tooltip: 'Elegir foto',
          ),
        ],
      ),
    );
  }
}

class _AudioRecorderPreview extends StatelessWidget {
  const _AudioRecorderPreview({
    required this.audioPath,
    required this.recording,
    required this.onStart,
    required this.onStop,
    required this.onDelete,
  });

  final String? audioPath;
  final bool recording;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final hasAudio = audioPath != null && File(audioPath!).existsSync();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: recording ? const Color(0x99E86F68) : const Color(0x22FFFFFF),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: recording
                ? const Color(0xFFE86F68)
                : const Color(0xFF4CC58A),
            child: Icon(
              recording ? Icons.graphic_eq : Icons.mic_none,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recording
                  ? 'Grabando nota de voz...'
                  : hasAudio
                  ? 'Audio listo para guardar.'
                  : 'Graba una nota de voz para esta esfera.',
              style: const TextStyle(color: Color(0xFFD6D2C8)),
            ),
          ),
          IconButton.filledTonal(
            onPressed: recording ? onStop : onStart,
            icon: Icon(recording ? Icons.stop : Icons.fiber_manual_record),
            tooltip: recording ? 'Detener grabacion' : 'Grabar audio',
          ),
          if (hasAudio || recording)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Borrar audio',
            ),
        ],
      ),
    );
  }
}
