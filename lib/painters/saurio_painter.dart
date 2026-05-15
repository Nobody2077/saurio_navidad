import 'dart:math' as math;

import 'package:flutter/material.dart';

enum SaurioMood { cozy, excited, recording, photo, surprise }

class SaurioMascot extends StatelessWidget {
  const SaurioMascot({
    super.key,
    required this.mood,
    required this.morning,
    required this.progress,
  });

  final SaurioMood mood;
  final bool morning;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(220, 188),
      painter: SaurioPainter(mood: mood, morning: morning, progress: progress),
    );
  }
}

class SaurioPainter extends CustomPainter {
  SaurioPainter({
    required this.mood,
    required this.morning,
    required this.progress,
  });

  final SaurioMood mood;
  final bool morning;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final breath = math.sin(progress * math.pi * 2) * 2.2;
    final tailWave = math.sin(progress * math.pi * 2 + .7) * 8;
    final blink = math.sin(progress * math.pi * 8) > .93;
    final isHappy = mood == SaurioMood.excited || mood == SaurioMood.photo;
    final isSurprised = mood == SaurioMood.surprise;
    final isRecording = mood == SaurioMood.recording;

    canvas.save();
    canvas.translate(8, 12 + breath);

    final body = Paint()..color = const Color(0xFF66C995);
    final bodyDark = Paint()..color = const Color(0xFF319366);
    final outline = Paint()..color = const Color(0xFF173E2C);
    final belly = Paint()..color = const Color(0xFFE7F0C6);
    final scarf = Paint()
      ..color = isRecording
          ? const Color(0xFF4CC58A)
          : morning
          ? const Color(0xFF527FD2)
          : const Color(0xFFD84646);
    final line = Paint()
      ..color = const Color(0xFF183526)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(105, 148), width: 146, height: 22),
      Paint()
        ..color = const Color(0x55000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final tail = Path()
      ..moveTo(67, 105)
      ..quadraticBezierTo(24, 112 + tailWave, 13, 75)
      ..quadraticBezierTo(45, 82 + tailWave * .35, 74, 94)
      ..close();
    canvas.drawPath(tail, bodyDark);
    canvas.drawPath(tail, line);

    canvas.drawOval(Rect.fromLTWH(58, 58, 96, 84), outline);
    canvas.drawOval(Rect.fromLTWH(61, 56, 92, 83), body);
    canvas.drawOval(Rect.fromLTWH(83, 76, 44, 50), belly);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(67, 86, 78, 17),
        const Radius.circular(8),
      ),
      scarf,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(120, 94, 17, 34),
        const Radius.circular(7),
      ),
      scarf,
    );

    canvas.drawOval(Rect.fromLTWH(76, 21, 88, 62), outline);
    canvas.drawOval(Rect.fromLTWH(73, 18, 88, 62), body);
    canvas.drawOval(Rect.fromLTWH(120, 34, 58, 38), outline);
    canvas.drawOval(Rect.fromLTWH(117, 31, 58, 38), body);
    canvas.drawCircle(const Offset(165, 47), 2.2, line);
    canvas.drawCircle(const Offset(166, 57), 2.2, line);

    for (var i = 0; i < 6; i++) {
      final spike = Path()
        ..moveTo(72 + i * 13, 20 + (i % 2) * 2)
        ..quadraticBezierTo(78 + i * 13, 1 + (i % 2) * 2, 85 + i * 13, 22)
        ..close();
      canvas.drawPath(spike, Paint()..color = const Color(0xFF2A845F));
    }

    final hat = Path()
      ..moveTo(88, 18)
      ..quadraticBezierTo(121, -8, 165, 28)
      ..quadraticBezierTo(130, 30, 96, 30)
      ..close();
    canvas.drawPath(
      hat,
      Paint()
        ..color = morning ? const Color(0xFFFFD990) : const Color(0xFFD94646),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(86, 25, 80, 10),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(const Offset(166, 29), 8, Paint()..color = Colors.white);

    _drawEye(canvas, const Offset(105, 42), blink || mood == SaurioMood.cozy);
    _drawEye(canvas, const Offset(132, 42), blink && !isSurprised);

    if (isSurprised) {
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(121, 57), width: 12, height: 15),
        Paint()..color = const Color(0xFF183526),
      );
    } else {
      final smileHeight = isHappy ? 20.0 : 13.0;
      canvas.drawArc(
        Rect.fromCenter(
          center: const Offset(121, 54),
          width: isRecording ? 22 : 36,
          height: smileHeight,
        ),
        0,
        math.pi,
        false,
        line,
      );
    }
    if (isHappy || isSurprised) {
      canvas.drawCircle(
        const Offset(94, 57),
        4,
        Paint()..color = const Color(0x33E86F68),
      );
      canvas.drawCircle(
        const Offset(143, 57),
        4,
        Paint()..color = const Color(0x33E86F68),
      );
    }

    canvas.drawOval(Rect.fromLTWH(146, 71, 30, 17), body);
    canvas.drawCircle(
      const Offset(174, 78),
      3,
      Paint()..color = isPhotoFlash ? const Color(0xFFFFE79A) : bodyDark.color,
    );
    canvas.drawPath(
      Path()
        ..moveTo(64, 80)
        ..quadraticBezierTo(44, 92, 48, 113),
      line..strokeWidth = 5,
    );

    canvas.drawOval(Rect.fromLTWH(73, 133, 30, 14), bodyDark);
    canvas.drawOval(Rect.fromLTWH(118, 133, 30, 14), bodyDark);
    _drawClaws(canvas, const Offset(82, 146));
    _drawClaws(canvas, const Offset(127, 146));

    if (isRecording) {
      _drawSoundWaves(canvas);
    }

    canvas.restore();
  }

  bool get isPhotoFlash => mood == SaurioMood.photo && progress < .5;

  void _drawEye(Canvas canvas, Offset center, bool closed) {
    if (closed) {
      canvas.drawArc(
        Rect.fromCenter(center: center, width: 13, height: 8),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = const Color(0xFF10231A)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      return;
    }
    canvas.drawCircle(center, 6.3, Paint()..color = const Color(0xFF10231A));
    canvas.drawCircle(
      center.translate(-2, -2),
      2.1,
      Paint()..color = Colors.white,
    );
  }

  void _drawClaws(Canvas canvas, Offset origin) {
    final claw = Paint()
      ..color = const Color(0xFFE7F0C6)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final dx = i * 6.0;
      canvas.drawLine(
        origin.translate(dx, 0),
        origin.translate(dx - 2, 4),
        claw,
      );
    }
  }

  void _drawSoundWaves(Canvas canvas) {
    final wave = Paint()
      ..color = const Color(0x994CC58A)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final grow = math.sin(progress * math.pi * 2 + i) * 2;
      canvas.drawArc(
        Rect.fromCircle(
          center: const Offset(184, 55),
          radius: 11 + i * 7 + grow,
        ),
        -.75,
        1.5,
        false,
        wave,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SaurioPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.morning != morning ||
        oldDelegate.progress != progress;
  }
}
