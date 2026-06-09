import 'package:flutter/material.dart';

import '../utils/date_helpers.dart';
import '../utils/day_phase.dart';
import 'cloud_chip.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isDecember,
    required this.memories,
    required this.phase,
    this.onSettings,
  });

  final bool isDecember;
  final int memories;
  final DayPhase phase;
  final VoidCallback? onSettings;

  static String _greeting(int hour) {
    if (hour >= 5 && hour < 12) return 'Buenos Días';
    if (hour >= 12 && hour < 19) return 'Buenas Tardes';
    return 'Buenas Noches';
  }

  static String _countdownLabel(DateTime now) {
    final days = daysUntilDecember(now);
    return days == 1 ? '1 día' : '$days días';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 48), // equilibra el ancho del engranaje
            Expanded(
              child: Center(
                child: CloudChip(
                  label: _greeting(now.hour),
                  phase: phase,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
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
        const SizedBox(height: 12),
        // Fecha (izquierda) y días (derecha) en la misma fila, separados
        Row(
          children: [
            CloudChip(
              icon: Icons.calendar_today,
              label: '${now.day}/${now.month}/${now.year}',
              phase: phase,
            ),
            const Spacer(),
            CloudChip(
              icon: Icons.lock_clock,
              label: isDecember ? 'diciembre activo' : _countdownLabel(now),
              phase: phase,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Recuerdos (más al centro)
        Align(
          alignment: Alignment.center,
          child: CloudChip(
            icon: Icons.auto_awesome,
            label: '$memories recuerdos',
            phase: phase,
          ),
        ),
      ],
    );
  }
}
