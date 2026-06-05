import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifPrefs {
  const NotifPrefs({
    required this.enabled,
    required this.weekday,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int weekday; // 0 = todos los días, 1 = lunes … 7 = domingo
  final int hour;
  final int minute;
}

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'saurio_recordatorios';
  static const _channelName = 'Recordatorios de Saurio';
  static const _notifId = 42;

  static const _kEnabled = 'notif_enabled';
  static const _kWeekday = 'notif_weekday';
  static const _kHour = 'notif_hour';
  static const _kMinute = 'notif_minute';

  static const _messages = [
    'El árbol te extraña. ¿Hay algo nuevo que colgar?',
    'Saurio pregunta: ¿qué pasó esta semana?',
    'Hay espacio en el árbol para un recuerdo nuevo.',
    'Las esferas se ven mejor cuando se les visita.',
    'Un momento pequeño también merece una esfera.',
    'Saurio está aquí, esperándote con calma.',
  ];

  Future<void> init() async {
    tz.initializeTimeZones();
    final zoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zoneName));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings);
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  Future<NotifPrefs> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return NotifPrefs(
      enabled: prefs.getBool(_kEnabled) ?? false,
      weekday: prefs.getInt(_kWeekday) ?? 0,
      hour: prefs.getInt(_kHour) ?? 20,
      minute: prefs.getInt(_kMinute) ?? 0,
    );
  }

  Future<void> saveAndSchedule(NotifPrefs notifPrefs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, notifPrefs.enabled);
    await prefs.setInt(_kWeekday, notifPrefs.weekday);
    await prefs.setInt(_kHour, notifPrefs.hour);
    await prefs.setInt(_kMinute, notifPrefs.minute);

    await _plugin.cancel(_notifId);
    if (!notifPrefs.enabled) return;

    final time = TimeOfDay(hour: notifPrefs.hour, minute: notifPrefs.minute);
    if (notifPrefs.weekday == 0) {
      await _scheduleDaily(time);
    } else {
      await _scheduleWeekly(notifPrefs.weekday, time);
    }
  }

  Future<void> _scheduleDaily(TimeOfDay time) async {
    await _plugin.zonedSchedule(
      _notifId,
      'Saurio te espera 🌿',
      _randomMessage(),
      _nextDaily(time),
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeekly(int weekday, TimeOfDay time) async {
    await _plugin.zonedSchedule(
      _notifId,
      'Saurio te espera 🌿',
      _randomMessage(),
      _nextWeekly(weekday, time),
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static NotificationDetails _details() => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription:
              'Recordatorios amables para visitar el árbol de recuerdos',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      );

  static tz.TZDateTime _nextDaily(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, time.hour, time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime _nextWeekly(int weekday, TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, time.hour, time.minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static String _randomMessage() =>
      _messages[Random().nextInt(_messages.length)];
}
