import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/day_phase.dart';

class SnowField extends StatelessWidget {
  const SnowField({super.key, required this.progress, required this.phase});

  final double progress;
  final DayPhase phase;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowPainter(progress: progress, phase: phase),
    );
  }
}

class SnowPainter extends CustomPainter {
  SnowPainter({required this.progress, required this.phase});

  final double progress;
  final DayPhase phase;

  @override
  void paint(Canvas canvas, Size size) {
    if (phase.showSun) {
      final isMidday = phase == DayPhase.midday;
      canvas.drawCircle(
        Offset(size.width * (isMidday ? .5 : .82), size.height * (isMidday ? .06 : .08)),
        isMidday ? 46 : 36,
        Paint()
          ..color = phase.sunGlow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: phase.snowOpacity);
    final count = phase.snowCount;
    for (var i = 0; i < count; i++) {
      final x = (i * 47.0) % size.width;
      final y =
          ((i * 89.0) + progress * size.height * (20 + i % 6) / 10) %
          size.height;
      canvas.drawCircle(
        Offset(x + math.sin(progress * 6 + i) * 11, y),
        1.2 + (i % 3) * .55,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.phase != phase;
  }
}
