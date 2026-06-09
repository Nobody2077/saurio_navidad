import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Cielo nocturno vivo: estrellas que titilan (aparecen/desaparecen) y
/// estrellas fugaces ocasionales con trayectoria aleatoria.
/// Se dibuja solo de noche, por código, sin assets.
class NightSky extends StatefulWidget {
  const NightSky({super.key});

  @override
  State<NightSky> createState() => _NightSkyState();
}

class _NightSkyState extends State<NightSky> with TickerProviderStateMixin {
  late final AnimationController _twinkle;
  late final AnimationController _shoot;
  final _random = math.Random();

  // Trayectoria de la estrella fugaz (en fracciones 0..1 de la pantalla).
  Offset _shootStart = const Offset(.2, .1);
  Offset _shootEnd = const Offset(.5, .35);

  @override
  void initState() {
    super.initState();
    _twinkle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
    _shoot = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _scheduleNextShoot();
      });
    _scheduleNextShoot();
  }

  void _scheduleNextShoot() {
    final delay = Duration(milliseconds: 2500 + _random.nextInt(4000));
    Future.delayed(delay, () {
      if (!mounted) return;
      _newShootPath();
      _shoot.forward(from: 0);
    });
  }

  void _newShootPath() {
    final startX = .08 + _random.nextDouble() * .6;
    final startY = .04 + _random.nextDouble() * .26;
    final len = .24 + _random.nextDouble() * .22;
    _shootStart = Offset(startX, startY);
    _shootEnd = Offset(startX + len, startY + len * .55);
  }

  @override
  void dispose() {
    _twinkle.dispose();
    _shoot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_twinkle, _shoot]),
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _NightSkyPainter(
            twinkle: _twinkle.value,
            shoot: _shoot.value,
            shootActive: _shoot.isAnimating,
            shootStart: _shootStart,
            shootEnd: _shootEnd,
          ),
        );
      },
    );
  }
}

class _NightSkyPainter extends CustomPainter {
  _NightSkyPainter({
    required this.twinkle,
    required this.shoot,
    required this.shootActive,
    required this.shootStart,
    required this.shootEnd,
  });

  final double twinkle;
  final double shoot;
  final bool shootActive;
  final Offset shootStart;
  final Offset shootEnd;

  static const _starCount = 60;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = twinkle * math.pi * 2;

    for (var i = 0; i < _starCount; i++) {
      // Posiciones pseudo-aleatorias deterministas, concentradas en el cielo
      // (parte superior, donde están las nubes).
      final x = ((i * 97) % 100) / 100 * size.width;
      final y = ((i * 53) % 78) / 100 * size.height;

      // Titileo desfasado por estrella.
      final t = (math.sin(phase + i * 1.7) + 1) / 2; // 0..1
      final alpha = (.15 + t * .8).clamp(0.0, 1.0);
      final radius = .6 + (i % 3) * .5;

      final paint = Paint()..color = Colors.white.withValues(alpha: alpha);

      // Cada cierta estrella es un "destello" de 4 puntas que pulsa.
      if (i % 5 == 0) {
        final r = radius + 1.6 + t * 1.8;
        canvas.drawPath(_sparkle(Offset(x, y), r, r * .32), paint);
      } else {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    if (shootActive) {
      _paintShootingStar(canvas, size);
    }
  }

  void _paintShootingStar(Canvas canvas, Size size) {
    final s = Offset(shootStart.dx * size.width, shootStart.dy * size.height);
    final e = Offset(shootEnd.dx * size.width, shootEnd.dy * size.height);
    final head = Offset.lerp(s, e, shoot)!;
    final dir = e - s;
    final tailStart = head - dir * .2; // cola corta detrás de la cabeza
    final a = math.sin(shoot * math.pi); // aparece y desaparece

    canvas.drawLine(
      tailStart,
      head,
      Paint()
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            const Color(0x00FFFFFF),
            Colors.white.withValues(alpha: .9 * a),
          ],
        ).createShader(Rect.fromPoints(tailStart, head)),
    );
    canvas.drawCircle(
      head,
      2.4,
      Paint()
        ..color = Colors.white.withValues(alpha: a)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }

  Path _sparkle(Offset c, double outer, double inner) {
    final path = Path();
    for (var k = 0; k < 8; k++) {
      final ang = k * math.pi / 4 - math.pi / 2;
      final rad = k.isEven ? outer : inner;
      final pt = Offset(c.dx + math.cos(ang) * rad, c.dy + math.sin(ang) * rad);
      k == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant _NightSkyPainter oldDelegate) {
    return oldDelegate.twinkle != twinkle ||
        oldDelegate.shoot != shoot ||
        oldDelegate.shootActive != shootActive;
  }
}
