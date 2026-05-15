import 'package:flutter/material.dart';

import '../models/memory.dart';

class DecemberCalendar extends StatelessWidget {
  const DecemberCalendar({
    super.key,
    required this.isDecember,
    required this.memories,
  });

  final bool isDecember;
  final List<Memory> memories;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day;
    final activeDays = isDecember ? today.clamp(1, 25) : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calendario emocional',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          itemCount: 25,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final day = index + 1;
            final unlocked = day <= activeDays;
            final count = memories
                .where((memory) => memory.date.day == day)
                .length;
            return Container(
              decoration: BoxDecoration(
                color: unlocked
                    ? const Color(0x334CC58A)
                    : const Color(0x16FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: unlocked
                      ? const Color(0xFF75D69E)
                      : const Color(0x22FFFFFF),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    unlocked ? Icons.lock_open : Icons.lock_outline,
                    size: 16,
                    color: const Color(0xFFE9D18A),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$day',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFBFC8BE),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
