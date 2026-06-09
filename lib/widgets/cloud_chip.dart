import 'package:flutter/material.dart';

import '../utils/day_phase.dart';

/// Chip con forma de nube para el saludo y el contador de recuerdos.
/// El texto va siempre oscuro (se lee sobre la nube clara en cualquier fase);
/// la nube se tiñe según el momento del día.
class CloudChip extends StatelessWidget {
  const CloudChip({
    super.key,
    required this.label,
    required this.phase,
    this.icon,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
  });

  final String label;
  final DayPhase phase;
  final IconData? icon;
  final double fontSize;
  final FontWeight fontWeight;

  static const _textColor = Color(0xFF283445);
  static const _iconColor = Color(0xFFC79A3E);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CloudPainter(color: phase.cloudColor),
      child: Padding(
        // Más espacio arriba para que los bultos de la nube no tapen el texto.
        padding: EdgeInsets.fromLTRB(
          icon == null ? 22 : 18,
          fontSize * 0.85 + 8,
          22,
          10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: fontSize + 2, color: _iconColor),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: TextStyle(
                color: _textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  _CloudPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _cloudPath(size);

    // Sombra suave
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Cuerpo de la nube
    canvas.drawPath(path, Paint()..color = color);

    // Brillo sutil en la parte superior
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: .35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  Path _cloudPath(Size size) {
    final w = size.width;
    final h = size.height;

    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.05, h * 0.46, w * 0.90, h * 0.50),
          Radius.circular(h * 0.26),
        ),
      );

    Path withBump(Path base, double cx, double cy, double r) {
      return Path.combine(
        PathOperation.union,
        base,
        Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
      );
    }

    path = withBump(path, w * 0.50, h * 0.34, h * 0.34); // bulto central
    path = withBump(path, w * 0.28, h * 0.46, h * 0.27);
    path = withBump(path, w * 0.72, h * 0.46, h * 0.27);
    path = withBump(path, w * 0.13, h * 0.60, h * 0.22); // lóbulos laterales
    path = withBump(path, w * 0.87, h * 0.60, h * 0.22);
    return path;
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
