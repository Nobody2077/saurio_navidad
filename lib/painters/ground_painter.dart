import 'package:flutter/material.dart';

import '../utils/day_phase.dart';

/// Suelo nevado donde se paran el árbol, Saurio y el cofre.
/// Recolorea según el momento del día.
class SnowGround extends StatelessWidget {
  const SnowGround({super.key, required this.phase});

  final DayPhase phase;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SnowGroundPainter(phase: phase), size: Size.infinite);
  }
}

class SnowGroundPainter extends CustomPainter {
  SnowGroundPainter({required this.phase});

  final DayPhase phase;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = phase.groundColors;
    final surface = size.height * .2; // altura de la línea de nieve

    // Curva superior de la loma nevada
    Path surfacePath() => Path()
      ..moveTo(0, surface + 18)
      ..quadraticBezierTo(
        size.width * .28,
        surface - 16,
        size.width * .54,
        surface + 4,
      )
      ..quadraticBezierTo(
        size.width * .80,
        surface + 22,
        size.width,
        surface - 8,
      );

    // Cuerpo del suelo
    final body = surfacePath()
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors[0], colors[1]],
        ).createShader(Rect.fromLTWH(0, surface - 20, size.width, size.height)),
    );

    // Brillo suave en el borde de la nieve
    canvas.drawPath(
      surfacePath(),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = colors[0].withValues(alpha: .75)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(covariant SnowGroundPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
