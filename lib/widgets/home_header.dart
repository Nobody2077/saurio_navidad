import 'package:flutter/material.dart';

import '../utils/date_helpers.dart';
import 'pill.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isDecember,
    required this.memories,
    this.onSettings,
  });

  final bool isDecember;
  final int memories;
  final VoidCallback? onSettings;

  static String _greeting(int hour) {
    if (hour >= 5 && hour < 12) return 'Buenos días';
    if (hour >= 12 && hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  static String _countdownLabel(DateTime now) {
    final days = daysUntilDecember(now);
    return days == 1 ? '1 día para diciembre' : '$days días para diciembre';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _greeting(now.hour),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
            IconButton(
              onPressed: onSettings,
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Ajustes',
              color: const Color(0xFFE0C073),
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
            Pill(
              icon: Icons.calendar_today,
              label: '${now.day}/${now.month}/${now.year}',
            ),
            Pill(icon: Icons.auto_awesome, label: '$memories recuerdos'),
            Pill(
              icon: Icons.lock_clock,
              label: isDecember
                  ? 'diciembre activo'
                  : _countdownLabel(now),
            ),
          ],
        ),
      ],
    );
  }
}
