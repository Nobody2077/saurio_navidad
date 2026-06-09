import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../painters/saurio_painter.dart';
import '../utils/day_phase.dart';

const double _kTailHeight = 9;

class SaurioCompanion extends StatelessWidget {
  const SaurioCompanion({
    super.key,
    required this.mood,
    required this.message,
    required this.phase,
  });

  final SaurioMood mood;
  final String message;
  final DayPhase phase;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Burbuja anclada justo encima de la cabeza de Saurio
          Positioned(
            left: 0,
            right: 0,
            bottom: 200,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _SpeechBubble(message: message, phase: phase)
                  .animate(target: message.isEmpty ? 0 : 1)
                  .fade(duration: 220.ms)
                  .scale(
                    begin: const Offset(.96, .96),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
            ),
          ),
          // Mascota con flote sutil
          Positioned(
            bottom: 0,
            left: 0,
            child: SaurioMascot(mood: mood)
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(begin: 0, end: -4, duration: 2200.ms),
          ),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.message, required this.phase});

  final String message;
  final DayPhase phase;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(
        color: phase.bubbleColor,
        border: phase.bubbleBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 10, 13, 10 + _kTailHeight),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: _Typewriter(
            text: message,
            style: TextStyle(
              color: phase.bubbleTextColor,
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Revela el texto letra por letra. Reinicia cuando el mensaje cambia.
class _Typewriter extends StatefulWidget {
  const _Typewriter({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<_Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<_Typewriter> {
  Timer? _timer;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(_Typewriter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _start();
  }

  void _start() {
    _timer?.cancel();
    _count = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (_count >= widget.text.length) {
        timer.cancel();
        return;
      }
      setState(() => _count++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Texto completo transparente: fija el tamaño para que la burbuja no
        // crezca mientras se escribe.
        Text(
          widget.text,
          style: widget.style.copyWith(color: const Color(0x00000000)),
        ),
        Text(widget.text.substring(0, _count), style: widget.style),
      ],
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({required this.color, required this.border});

  final Color color;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - _kTailHeight),
      const Radius.circular(12),
    );
    final tailX = size.width * 0.42;
    final tail = Path()
      ..moveTo(tailX - 8, size.height - _kTailHeight + 0.5)
      ..lineTo(tailX, size.height) // punta hacia abajo, apuntando a Saurio
      ..lineTo(tailX + 8, size.height - _kTailHeight + 0.5)
      ..close();
    final shape = Path()
      ..addRRect(body)
      ..addPath(tail, Offset.zero);

    // Sombra suave
    canvas.drawPath(
      shape.shift(const Offset(0, 3)),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Cuerpo
    canvas.drawPath(shape, Paint()..color = color);
    // Borde
    canvas.drawPath(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.border != border;
  }
}
