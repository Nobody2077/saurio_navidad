import 'package:flutter/material.dart';

import 'pill.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isDecember,
    required this.memories,
    this.onNotificationSettings,
  });

  final bool isDecember;
  final int memories;
  final VoidCallback? onNotificationSettings;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'SaurioNavidad',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
            IconButton(
              onPressed: onNotificationSettings,
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Recordatorios',
              color: const Color(0xFFE0C073),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x22FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x26FFFFFF)),
              ),
              child: Text('${now.day}/${now.month}/${now.year}'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isDecember
              ? 'El arbol desperto y esta revelando recuerdos.'
              : 'El arbol duerme suave hasta diciembre.',
          style: const TextStyle(color: Color(0xFFD6D2C8), fontSize: 15),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill(icon: Icons.auto_awesome, label: '$memories recuerdos'),
            Pill(
              icon: Icons.lock_clock,
              label: isDecember ? 'diciembre activo' : 'modo espera',
            ),
            const Pill(icon: Icons.favorite, label: 'frase del dia'),
          ],
        ),
      ],
    );
  }
}
