import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/date_helpers.dart';
import '../utils/memory_style.dart';

class CapsuleChestSheet extends StatelessWidget {
  const CapsuleChestSheet({
    super.key,
    required this.memories,
    required this.onTap,
  });

  final List<Memory> memories;
  final ValueChanged<Memory> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cofre secreto',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Capsulas guardadas con candado y fecha propia.',
            style: TextStyle(color: Color(0xFFC9D3CC)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: memories.isEmpty
                ? const _EmptyChest()
                : ListView.builder(
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memory = memories[index];
                      return _CapsuleTile(memory: memory, onTap: onTap);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChest extends StatelessWidget {
  const _EmptyChest();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, color: Color(0xFFE9D18A), size: 44),
          SizedBox(height: 10),
          Text('Todavia no hay capsulas guardadas.'),
        ],
      ),
    );
  }
}

class _CapsuleTile extends StatelessWidget {
  const _CapsuleTile({required this.memory, required this.onTap});

  final Memory memory;
  final ValueChanged<Memory> onTap;

  @override
  Widget build(BuildContext context) {
    final unlocked = memory.isUnlocked;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: unlocked ? () => onTap(memory) : null,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: unlocked ? const Color(0x223C8E64) : const Color(0x18FFFFFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: unlocked
                  ? const Color(0x6675D69E)
                  : const Color(0x22FFFFFF),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor(memory.type).withValues(alpha: .22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: typeColor(memory.type)),
                ),
                child: Icon(
                  unlocked ? Icons.lock_open : Icons.lock,
                  color: const Color(0xFFE9D18A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      unlocked
                          ? 'Lista para abrir'
                          : 'Se abre el ${shortDate(memory.lockedUntil!)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFC9D3CC)),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked ? Icons.chevron_right : typeIcon(memory.type),
                color: unlocked ? Colors.white : typeColor(memory.type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
