import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({super.key, this.icon, this.emoji, required this.label})
    : assert(icon != null || emoji != null, 'Provide icon or emoji');

  final IconData? icon;
  final String? emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Widget leading = (emoji != null && emoji!.isNotEmpty)
        ? Text(emoji!, style: const TextStyle(fontSize: 15))
        : Icon(icon!, size: 16, color: const Color(0xFFE9D18A));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
