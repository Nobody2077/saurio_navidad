import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<NotificationSettingsSheet> {
  bool _enabled = false;
  int _weekday = 0;
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await NotificationService.instance.loadPrefs();
    if (!mounted) return;
    setState(() {
      _enabled = prefs.enabled;
      _weekday = prefs.weekday;
      _time = TimeOfDay(hour: prefs.hour, minute: prefs.minute);
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    if (_enabled) {
      final granted = await NotificationService.instance.requestPermission();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activa el permiso de notificaciones en ajustes.'),
          ),
        );
        setState(() => _saving = false);
        return;
      }
    }

    await NotificationService.instance.saveAndSchedule(NotifPrefs(
      enabled: _enabled,
      weekday: _weekday,
      hour: _time.hour,
      minute: _time.minute,
    ));

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _enabled ? 'Recordatorio activado.' : 'Recordatorio desactivado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.notifications_outlined, color: Color(0xFFE0C073)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Recordatorios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              Switch(
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _enabled
                ? 'Saurio te avisará cuando sea momento de visitar el árbol.'
                : 'Los recordatorios están desactivados.',
            style: const TextStyle(color: Color(0xFFD6D2C8), fontSize: 13),
          ),

          // Config (solo visible si está activado)
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _enabled
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      const Text(
                        '¿Cuándo?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _DaySelector(
                        selected: _weekday,
                        onSelect: (d) => setState(() => _weekday = d),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        '¿A qué hora?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _TimeButton(
                        time: _time,
                        onPick: (t) => setState(() => _time = t),
                      ),
                      const SizedBox(height: 16),
                      _NotifPreview(weekday: _weekday, time: _time),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selector de día ──────────────────────────────────────────────────────────

class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  static const _days = <(int, String)>[
    (0, 'Todos los días'),
    (1, 'Lu'),
    (2, 'Ma'),
    (3, 'Mi'),
    (4, 'Ju'),
    (5, 'Vi'),
    (6, 'Sá'),
    (7, 'Do'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _days.map((day) {
        final isSelected = selected == day.$1;
        return FilterChip(
          selected: isSelected,
          label: Text(day.$2),
          onSelected: (_) => onSelect(day.$1),
        );
      }).toList(),
    );
  }
}

// ── Botón de hora ────────────────────────────────────────────────────────────

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.time, required this.onPick});

  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onPick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0x18FFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x22FFFFFF)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              size: 20,
              color: Color(0xFFE0C073),
            ),
            const SizedBox(width: 10),
            Text(
              _fmt(time),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Text(
              'Cambiar',
              style: TextStyle(color: Color(0xFF5EC48A), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ── Preview de la notificación ───────────────────────────────────────────────

class _NotifPreview extends StatelessWidget {
  const _NotifPreview({required this.weekday, required this.time});

  final int weekday;
  final TimeOfDay time;

  static const _dayNames = [
    'todos los días',
    'los lunes',
    'los martes',
    'los miércoles',
    'los jueves',
    'los viernes',
    'los sábados',
    'los domingos',
  ];

  @override
  Widget build(BuildContext context) {
    final when = _dayNames[weekday];
    final hour =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x14E0C073),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x33E0C073)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌿', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saurio te espera 🌿',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'El árbol te extraña. ¿Hay algo nuevo que colgar?',
                  style: TextStyle(fontSize: 12, color: Color(0xFFD6D2C8)),
                ),
                const SizedBox(height: 6),
                Text(
                  'Se enviará $when a las $hour',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A9A8A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
