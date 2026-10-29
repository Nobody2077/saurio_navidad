import 'package:flutter/material.dart';

import '../services/sound_service.dart';

/// Interruptores de efectos y música, más una lista para escuchar cada efecto.
class SoundSettingsSheet extends StatefulWidget {
  const SoundSettingsSheet({super.key});

  @override
  State<SoundSettingsSheet> createState() => _SoundSettingsSheetState();
}

class _SoundSettingsSheetState extends State<SoundSettingsSheet> {
  final SoundService _sound = SoundService.instance;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .72,
      minChildSize: .35,
      maxChildSize: .92,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Row(
              children: const [
                Icon(Icons.music_note_outlined, color: Color(0xFFE0C073)),
                SizedBox(width: 10),
                Text(
                  'Sonidos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Efectos de sonido'),
              subtitle: const Text('Esferas, cofre, Saurio y más'),
              value: _sound.effectsOn,
              onChanged: (on) async {
                await _sound.setEffects(on);
                setState(() {});
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Música navideña'),
              subtitle: const Text('Caja musical suave mientras la app está abierta'),
              value: _sound.musicOn,
              onChanged: (on) async {
                await _sound.setMusic(on);
                setState(() {});
              },
            ),
            const SizedBox(height: 14),
            const Text(
              'Escuchar efectos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            for (final sfx in Sfx.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(sfx.label),
                subtitle: Text(
                  '${sfx.file}.wav',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFBFC8BE)),
                ),
                trailing: const Icon(
                  Icons.play_circle_outline,
                  color: Color(0xFFE0C073),
                ),
                onTap: () => _sound.play(sfx, force: true),
              ),
          ],
        );
      },
    );
  }
}
