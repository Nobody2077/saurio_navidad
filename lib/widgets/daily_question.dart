import 'package:flutter/material.dart';

class DailyQuestion extends StatelessWidget {
  const DailyQuestion({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x221A352C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x334CC58A)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paso algo bonito hoy?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                SizedBox(height: 4),
                Text(
                  'Guarda una esfera nueva para que el arbol gane vida.',
                  style: TextStyle(color: Color(0xFFC9D3CC)),
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onAdd,
            icon: const Icon(Icons.add_reaction_outlined),
            tooltip: 'Agregar recuerdo',
          ),
        ],
      ),
    );
  }
}
