import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/memory_style.dart';

class ChristmasTreeView extends StatelessWidget {
  const ChristmasTreeView({
    super.key,
    required this.progress,
    required this.memories,
    required this.lit,
  });

  final double progress;
  final List<Memory> memories;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(310, 380),
      painter: ChristmasTreePainter(
        progress: progress,
        memories: memories,
        lit: lit,
      ),
    );
  }
}

class ChristmasTreePainter extends CustomPainter {
  ChristmasTreePainter({
    required this.progress,
    required this.memories,
    required this.lit,
  });

  final double progress;
  final List<Memory> memories;
  final bool lit;

  @override
  void paint(Canvas canvas, Size size) {
    _drawShadow(canvas, size);
    _drawTrunk(canvas, size);
    _drawBranches(canvas, size);
    _drawLights(canvas, size);
    _drawMemoryOrnaments(canvas, size);
    _drawStar(canvas, Offset(size.width / 2, size.height * .07), 23, 10);
  }

  void _drawShadow(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .88);
    final shadow = Paint()
      ..color = const Color(0x66000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size.width * .72, height: 34),
      shadow,
    );
  }

  void _drawTrunk(Canvas canvas, Size size) {
    final trunk = Paint()..color = const Color(0xFF7A4930);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .43,
          size.height * .72,
          size.width * .14,
          size.height * .16,
        ),
        const Radius.circular(8),
      ),
      trunk,
    );
  }

  void _drawBranches(Canvas canvas, Size size) {
    for (var i = 0; i < 5; i++) {
      final top = size.height * (.08 + i * .12);
      final width = size.width * (.38 + i * .11);
      final height = size.height * .24;
      final path = Path()
        ..moveTo(size.width / 2, top)
        ..quadraticBezierTo(
          size.width / 2 - width * .42,
          top + height * .45,
          size.width / 2 - width / 2,
          top + height,
        )
        ..quadraticBezierTo(
          size.width / 2,
          top + height * .85,
          size.width / 2 + width / 2,
          top + height,
        )
        ..quadraticBezierTo(
          size.width / 2 + width * .42,
          top + height * .45,
          size.width / 2,
          top,
        )
        ..close();

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Color.lerp(
              const Color(0xFF123A2D),
              const Color(0xFF247B55),
              lit ? .8 : .32,
            )!,
            Color.lerp(
              const Color(0xFF071B18),
              const Color(0xFF114431),
              lit ? .7 : .18,
            )!,
          ],
        ).createShader(path.getBounds());
      canvas.drawPath(
        path.shift(const Offset(9, 8)),
        Paint()..color = const Color(0x22000000),
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawLights(Canvas canvas, Size size) {
    final lightCount = math.max(8, memories.length * 3);
    final glow = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, lit ? 14 : 5);
    for (var i = 0; i < lightCount; i++) {
      final angle = i * 1.73 + progress * math.pi * 2;
      final y = size.height * (.2 + (i / lightCount) * .55);
      final x =
          size.width / 2 +
          math.sin(angle) * size.width * (.08 + (i % 5) * .035);
      final color = [
        const Color(0xFFE9D18A),
        const Color(0xFFE86F68),
        const Color(0xFF70D6A7),
        const Color(0xFF8FB7FF),
      ][i % 4];
      glow.color = color.withValues(alpha: lit ? .9 : .24);
      canvas.drawCircle(Offset(x, y), lit ? 4.8 : 3, glow);
      canvas.drawCircle(
        Offset(x, y),
        lit ? 2.6 : 1.6,
        Paint()..color = color.withValues(alpha: lit ? 1 : .4),
      );
    }
  }

  void _drawMemoryOrnaments(Canvas canvas, Size size) {
    final visible = memories.take(28).toList();
    for (var i = 0; i < visible.length; i++) {
      final memory = visible[i];
      final layer = i % 6;
      final row = i ~/ 4;
      final rowOffset = math.min(row * .075, .48);
      final y = size.height * (.24 + rowOffset);
      final spread = size.width * (.09 + (y / size.height) * .24);
      final x =
          size.width / 2 +
          math.sin(i * 2.04) * spread +
          math.cos(progress * math.pi * 2 + i) * 1.5;
      final center = Offset(x, y + layer * 2.5);
      final radius = memory.type == MemoryType.photo ? 8.8 : 7.5;
      final color = typeColor(memory.type);

      canvas.drawCircle(
        center.translate(0, 2.2),
        radius + 1.5,
        Paint()..color = const Color(0x66000000),
      );
      canvas.drawCircle(
        center,
        radius + 5,
        Paint()
          ..color = color.withValues(alpha: lit ? .18 : .1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawCircle(center, radius, Paint()..color = color);
      canvas.drawCircle(
        center.translate(-radius * .35, -radius * .38),
        radius * .25,
        Paint()..color = Colors.white.withValues(alpha: .72),
      );
      if (memory.type == MemoryType.photo) {
        canvas.drawCircle(
          center,
          radius * .55,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.7
            ..color = Colors.white.withValues(alpha: .9),
        );
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double outer, double inner) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()..color = lit ? const Color(0xFFFFE79A) : const Color(0xFF82764D),
    );
  }

  @override
  bool shouldRepaint(covariant ChristmasTreePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.memories != memories ||
        oldDelegate.lit != lit;
  }
}
