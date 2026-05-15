import 'dart:io';

import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/memory_style.dart';

class MemoryList extends StatelessWidget {
  const MemoryList({
    super.key,
    required this.memories,
    required this.onTap,
    this.compact = true,
  });

  final List<Memory> memories;
  final ValueChanged<Memory> onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Text(
          'Aun no hay recuerdos visibles.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact)
          const Text(
            'Esferas visibles',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
        if (compact) const SizedBox(height: 10),
        ...memories.map(
          (memory) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => onTap(memory),
              tileColor: const Color(0x18FFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: _MemoryAvatar(memory: memory),
              title: Text(
                memory.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${typeLabel(memory.type)} · ${memory.emotion}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemoryAvatar extends StatelessWidget {
  const _MemoryAvatar({required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final path = memory.photoPath;
    if (memory.type == MemoryType.photo &&
        path != null &&
        File(path).existsSync()) {
      return CircleAvatar(backgroundImage: FileImage(File(path)));
    }

    return CircleAvatar(
      backgroundColor: typeColor(memory.type),
      child: Icon(typeIcon(memory.type), color: Colors.white, size: 20),
    );
  }
}
