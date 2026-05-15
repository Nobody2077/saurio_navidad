import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFE9D18A)),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
