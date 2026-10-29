import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/memory.dart';

/// Efectos de la app. Los archivos viven en `assets/sounds/` y se generan con
/// `tool/gen_sounds.dart`.
enum Sfx {
  esferaGuardar('esfera_guardar', 'Guardar recuerdo'),
  esferaNote('esfera_note', 'Tocar esfera: nota'),
  esferaPhoto('esfera_photo', 'Tocar esfera: foto'),
  esferaAudio('esfera_audio', 'Tocar esfera: audio'),
  esferaPlace('esfera_place', 'Tocar esfera: lugar'),
  esferaHeart('esfera_heart', 'Tocar esfera: corazón'),
  esferaGoal('esfera_goal', 'Tocar esfera: meta'),
  saurioTocar('saurio_tocar', 'Tocar a Saurio'),
  cofreAbrir('cofre_abrir', 'Abrir el cofre'),
  capsulaAbrir('capsula_abrir', 'Abrir cápsula (24 dic)'),
  diaDesbloquear('dia_desbloquear', 'Desbloquear día'),
  diciembreInicio('diciembre_inicio', 'Llegó diciembre'),
  grabarInicio('grabar_inicio', 'Empezar a grabar'),
  grabarFin('grabar_fin', 'Terminar de grabar'),
  borrar('borrar', 'Borrar recuerdo');

  const Sfx(this.file, this.label);

  final String file;
  final String label;

  static Sfx forMemory(MemoryType type) {
    switch (type) {
      case MemoryType.note:
        return Sfx.esferaNote;
      case MemoryType.photo:
        return Sfx.esferaPhoto;
      case MemoryType.audio:
        return Sfx.esferaAudio;
      case MemoryType.place:
        return Sfx.esferaPlace;
      case MemoryType.heart:
        return Sfx.esferaHeart;
      case MemoryType.goal:
        return Sfx.esferaGoal;
    }
  }
}

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  static const _effectsKey = 'sound_effects_on';
  static const _musicKey = 'sound_music_on';
  static const _musicAsset = 'sounds/musica_fondo.wav';

  // Los efectos se mezclan con la música de otras apps en vez de pausarla.
  static final _effectsContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  final List<AudioPlayer> _pool = [];
  final AudioPlayer _music = AudioPlayer();
  AppLifecycleListener? _lifecycle;
  int _next = 0;

  bool effectsOn = true;
  bool musicOn = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    effectsOn = prefs.getBool(_effectsKey) ?? true;
    musicOn = prefs.getBool(_musicKey) ?? false;

    for (var i = 0; i < 4; i++) {
      final player = AudioPlayer();
      await player.setAudioContext(_effectsContext);
      await player.setReleaseMode(ReleaseMode.stop);
      _pool.add(player);
    }
    await _music.setReleaseMode(ReleaseMode.loop);
    await _music.setVolume(.45);

    // La música solo suena con la app en primer plano.
    _lifecycle = AppLifecycleListener(
      onPause: () => _music.pause(),
      onResume: () {
        if (musicOn) {
          _music.resume();
        }
      },
    );
    if (musicOn) {
      await _music.play(AssetSource(_musicAsset));
    }
  }

  Future<void> play(Sfx sfx, {bool force = false}) async {
    if (!effectsOn && !force) {
      return;
    }
    final player = _pool[_next++ % _pool.length];
    try {
      await player.stop();
      await player.play(AssetSource('sounds/${sfx.file}.wav'));
    } catch (_) {
      // Un efecto que falla nunca debe interrumpir la app.
    }
  }

  Future<void> setEffects(bool on) async {
    effectsOn = on;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_effectsKey, on);
  }

  Future<void> setMusic(bool on) async {
    musicOn = on;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicKey, on);
    if (on) {
      await _music.play(AssetSource(_musicAsset));
    } else {
      await _music.stop();
    }
  }

  Future<void> dispose() async {
    _lifecycle?.dispose();
    await _music.dispose();
    for (final player in _pool) {
      await player.dispose();
    }
  }
}
