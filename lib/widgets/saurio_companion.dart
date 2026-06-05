import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../painters/saurio_painter.dart';

class SaurioCompanion extends StatelessWidget {
  const SaurioCompanion({
    super.key,
    required this.mood,
    required this.message,
  });

  final SaurioMood mood;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 6,
            child: _SpeechBubble(message: message)
                .animate(target: message.isEmpty ? 0 : 1)
                .fade(duration: 220.ms)
                .scale(
                  begin: const Offset(.96, .96),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SaurioMascot(mood: mood)
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(begin: 0, end: -4, duration: 2200.ms)
                .then()
                .moveY(begin: -4, end: 0, duration: 2200.ms),
          ),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xEE172019),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x335ED199)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFE8F3DC),
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
