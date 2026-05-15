import 'package:flutter/material.dart';

class GiftChest extends StatelessWidget {
  const GiftChest({super.key, required this.capsules});

  final int capsules;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF7A2F2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0C073), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Center(
              child: Container(width: 18, color: const Color(0xFFE0C073)),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(height: 17, color: const Color(0xFF9D3A38)),
          ),
          Positioned(
            right: 12,
            bottom: 10,
            child: Text(
              '$capsules',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const Icon(Icons.lock_clock, color: Color(0xFFFFE0A1)),
        ],
      ),
    );
  }
}
