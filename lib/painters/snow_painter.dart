import 'dart:math' as math;

import 'package:flutter/material.dart';

class SnowField extends StatelessWidget {
  const SnowField({super.key, required this.progress, required this.morning});

  final double progress;
  final bool morning;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowPainter(progress: progress, morning: morning),
    );
  }
}

class SnowPainter extends CustomPainter {
  SnowPainter({required this.progress, required this.morning});

  final double progress;
  final bool morning;

  @override
  void paint(Canvas canvas, Size size) {
    if (morning) {
      canvas.drawCircle(
        Offset(size.width * .82, size.height * .08),
        36,
        Paint()
          ..color = const Color(0x55FFD99A)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: morning ? .42 : .62);
    for (var i = 0; i < 70; i++) {
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
    return oldDelegate.progress != progress || oldDelegate.morning != morning;
  }
}
