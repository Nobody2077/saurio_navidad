// Sintetiza los efectos de SaurioNavidad como WAV mono 16-bit.
// Uso: dart run tool/gen_sounds.dart assets/sounds
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const sr = 22050;
final rnd = Random(2077);

List<double> buf(double seconds) => List<double>.filled((seconds * sr).round(), 0);

double mtof(num midi) => 440 * pow(2, (midi - 69) / 12).toDouble();

/// Suma un "tin" de campana/cristal con parciales inarmónicos.
void bell(List<double> out, double start, double freq,
    {double amp = 1, double decay = .6, List<double> ratios = const [1, 2.0, 2.76, 5.4], List<double> amps = const [1, .3, .45, .18]}) {
  final s0 = (start * sr).round();
  final len = (decay * 6 * sr).round();
  for (var p = 0; p < ratios.length; p++) {
    final f = freq * ratios[p];
    if (f > sr / 2.2) continue;
    final d = decay / (1 + p * .8);
    for (var i = 0; i < len && s0 + i < out.length; i++) {
      final t = i / sr;
      final att = min(1.0, t / .002);
      out[s0 + i] += amp * amps[p] * att * exp(-t / d) * sin(2 * pi * f * t);
    }
  }
}

/// Seno con glissando exponencial f0 -> f1.
void sweep(List<double> out, double start, double dur, double f0, double f1,
    {double amp = 1, double decay = 1e9, double attack = .003}) {
  final s0 = (start * sr).round();
  final len = (dur * sr).round();
  var phase = 0.0;
  for (var i = 0; i < len && s0 + i < out.length; i++) {
    final t = i / sr;
    final f = f0 * pow(f1 / f0, t / dur);
    phase += 2 * pi * f / sr;
    final env = min(1.0, t / attack) * exp(-t / decay) * min(1.0, (dur - t) / .01);
    out[s0 + i] += amp * env * sin(phase);
  }
}

/// Filtro biquad RBJ (lowpass / bandpass / highpass) aplicado in situ.
class Biquad {
  Biquad(String type, double f, double q) {
    final w = 2 * pi * f / sr, a = sin(w) / (2 * q), c = cos(w);
    double b0, b1, b2;
    switch (type) {
      case 'lp':
        b0 = (1 - c) / 2; b1 = 1 - c; b2 = (1 - c) / 2;
      case 'hp':
        b0 = (1 + c) / 2; b1 = -(1 + c); b2 = (1 + c) / 2;
      default:
        b0 = a; b1 = 0; b2 = -a;
    }
    final a0 = 1 + a;
    _b0 = b0 / a0; _b1 = b1 / a0; _b2 = b2 / a0; _a1 = -2 * c / a0; _a2 = (1 - a) / a0;
  }
  late double _b0, _b1, _b2, _a1, _a2;
  double _x1 = 0, _x2 = 0, _y1 = 0, _y2 = 0;
  double run(double x) {
    final y = _b0 * x + _b1 * _x1 + _b2 * _x2 - _a1 * _y1 - _a2 * _y2;
    _x2 = _x1; _x1 = x; _y2 = _y1; _y1 = y;
    return y;
  }
}

void sparkles(List<double> out, double start, double span, int count, {double amp = .18}) {
  for (var k = 0; k < count; k++) {
    final t = start + rnd.nextDouble() * span;
    bell(out, t, 2200 + rnd.nextDouble() * 2400, amp: amp * (.5 + rnd.nextDouble() * .5), decay: .12);
  }
}

void normalize(List<double> x, double peak) {
  var m = 0.0;
  for (final v in x) { m = max(m, v.abs()); }
  if (m == 0) return;
  for (var i = 0; i < x.length; i++) { x[i] = x[i] / m * peak; }
  // Fundidos cortos para evitar clics.
  final f = (0.004 * sr).round();
  for (var i = 0; i < f && i < x.length; i++) {
    x[i] *= i / f;
    x[x.length - 1 - i] *= i / f;
  }
}

void writeWav(String path, List<double> x) {
  final data = ByteData(44 + x.length * 2);
  void str(int o, String s) { for (var i = 0; i < s.length; i++) { data.setUint8(o + i, s.codeUnitAt(i)); } }
  str(0, 'RIFF'); data.setUint32(4, 36 + x.length * 2, Endian.little); str(8, 'WAVE');
  str(12, 'fmt '); data.setUint32(16, 16, Endian.little); data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little); data.setUint32(24, sr, Endian.little);
  data.setUint32(28, sr * 2, Endian.little); data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little); str(36, 'data'); data.setUint32(40, x.length * 2, Endian.little);
  for (var i = 0; i < x.length; i++) {
    data.setInt16(44 + i * 2, (x[i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
  }
  File(path).writeAsBytesSync(data.buffer.asUint8List());
  stdout.writeln('${path.split(Platform.pathSeparator).last}  ${(x.length / sr).toStringAsFixed(2)} s');
}

// ---------------------------------------------------------------- sonidos

List<double> esferaGuardar() {
  final x = buf(1.4);
  const notes = [1047.0, 1319.0, 1568.0, 2093.0];
  for (var i = 0; i < notes.length; i++) {
    bell(x, i * .08, notes[i], amp: .7 + i * .1, decay: .35);
  }
  sparkles(x, .3, .6, 6, amp: .12);
  normalize(x, .8);
  return x;
}

List<double> esferaTocar(double freq, {bool doble = false}) {
  final x = buf(1.0);
  const glass = [1.0, 2.32, 4.25, 6.63];
  const glassAmp = [1.0, .4, .2, .08];
  bell(x, 0, freq, decay: .28, ratios: glass, amps: glassAmp);
  if (doble) bell(x, .09, freq * 1.5, amp: .6, decay: .25, ratios: glass, amps: glassAmp);
  normalize(x, .7);
  return x;
}

List<double> saurioTocar() {
  // "Rawr" tierno: voz con armónicos, formantes y vibrato áspero.
  const dur = .55;
  final x = buf(dur);
  var phase = 0.0;
  for (var i = 0; i < x.length; i++) {
    final t = i / sr;
    final f0 = t < .08 ? 300 + (t / .08) * 170 : 470 - (t - .08) / (dur - .08) * 170;
    phase += 2 * pi * f0 / sr;
    var v = 0.0;
    for (var h = 1; h <= 10; h++) {
      final fh = f0 * h;
      final formant = exp(-pow((fh - 950) / 380, 2)) + .6 * exp(-pow((fh - 2300) / 500, 2)) + .25;
      v += formant / h * sin(phase * h);
    }
    final rrr = .65 + .35 * sin(2 * pi * 32 * t);
    final env = min(1.0, t / .03) * min(1.0, (dur - t) / .16);
    x[i] = v * rrr * env;
  }
  normalize(x, .75);
  return x;
}

List<double> cofreAbrir() {
  final x = buf(1.6);
  // Crujido: impulsos "stick-slip" cada vez más rápidos por resonadores de madera.
  final creak = buf(.65);
  var t = 0.0;
  while (t < .62) {
    final rate = 35 + (t / .62) * 70;
    final i = (t * sr).round();
    if (i < creak.length) creak[i] += (.6 + rnd.nextDouble() * .4) * (rnd.nextBool() ? 1 : -1);
    t += 1 / rate * (.85 + rnd.nextDouble() * .3);
  }
  final r1 = Biquad('bp', 320, 9), r2 = Biquad('bp', 760, 7), r3 = Biquad('bp', 1500, 5);
  for (var i = 0; i < creak.length; i++) {
    final e = sin(pi * i / creak.length);
    x[i] += (r1.run(creak[i]) * 1.0 + r2.run(creak[i]) * .7 + r3.run(creak[i]) * .3) * e * 6;
  }
  // Brillo mágico al terminar de abrir.
  bell(x, .55, 1568, amp: .35, decay: .5);
  bell(x, .62, 2093, amp: .3, decay: .5);
  sparkles(x, .55, .8, 10, amp: .16);
  normalize(x, .8);
  return x;
}

List<double> cascabeles(List<double> x, double start, int shakes, double every) {
  for (var s = 0; s < shakes; s++) {
    final t0 = start + s * every;
    for (var k = 0; k < 5; k++) {
      bell(x, t0 + rnd.nextDouble() * .03, 3800 + rnd.nextDouble() * 1800,
          amp: .18, decay: .06, ratios: const [1, 1.41, 2.13], amps: const [1, .6, .3]);
    }
  }
  return x;
}

List<double> capsulaAbrir() {
  final x = buf(2.6);
  cascabeles(x, 0, 8, .12);
  // Fanfarria corta con timbre de metal suave.
  const notes = [784.0, 1047.0, 1319.0, 1568.0];
  const starts = [.35, .5, .65, .85];
  for (var n = 0; n < notes.length; n++) {
    final s0 = (starts[n] * sr).round();
    final dur = n == notes.length - 1 ? 1.2 : .2;
    final len = (dur * sr).round();
    for (var i = 0; i < len && s0 + i < x.length; i++) {
      final t = i / sr;
      final vib = n == notes.length - 1 ? 1 + .006 * sin(2 * pi * 5.5 * t) : 1.0;
      var v = 0.0;
      for (var h = 1; h <= 6; h++) { v += sin(2 * pi * notes[n] * vib * h * t) / (h * h * .7 + .3); }
      final env = min(1.0, t / .025) * min(1.0, (dur - t) / .08) * (n == notes.length - 1 ? exp(-t / .9) : 1);
      x[s0 + i] += v * env * .22;
    }
  }
  sparkles(x, .85, 1.3, 12, amp: .12);
  normalize(x, .8);
  return x;
}

List<double> diaDesbloquear() {
  final x = buf(.7);
  sweep(x, 0, .09, 900, 240, amp: 1, decay: .04);
  sparkles(x, .05, .35, 4, amp: .25);
  normalize(x, .7);
  return x;
}

List<double> diciembreInicio() {
  final x = buf(3.4);
  // "Fiuuu": ruido filtrado que sube.
  final n = (1.3 * sr).round();
  // Filtro recalculado por bloques, conservando su estado, para un barrido suave.
  var bp = Biquad('bp', 300, 3);
  for (var i = 0; i < n; i++) {
    if (i % 256 == 0) {
      final t = i / n;
      final next = Biquad('bp', 300 * pow(10, t).toDouble(), 3);
      next._x1 = bp._x1; next._x2 = bp._x2; next._y1 = bp._y1; next._y2 = bp._y2;
      bp = next;
    }
    final t = i / n;
    x[i] += bp.run(rnd.nextDouble() * 2 - 1) * pow(t, 1.5) * .9;
  }
  // Acorde de campanas: las luces se encienden.
  const chord = [523.0, 659.0, 784.0, 1047.0];
  for (var k = 0; k < chord.length; k++) {
    bell(x, 1.25 + k * .05, chord[k], amp: .5, decay: .9);
  }
  cascabeles(x, 1.25, 6, .14);
  sparkles(x, 1.3, 1.6, 16, amp: .1);
  normalize(x, .8);
  return x;
}

List<double> bip(bool subir) {
  final x = buf(.28);
  final a = subir ? 880.0 : 1320.0, b = subir ? 1320.0 : 880.0;
  sweep(x, 0, .1, a, a, amp: .8, decay: .2);
  sweep(x, .13, .12, b, b, amp: .8, decay: .2);
  normalize(x, .55);
  return x;
}

List<double> borrar() {
  final x = buf(.5);
  final lp = Biquad('lp', 900, .7);
  for (var i = 0; i < x.length; i++) {
    final t = i / sr;
    x[i] = lp.run(rnd.nextDouble() * 2 - 1) * min(1.0, t / .012) * exp(-t / .09);
  }
  sweep(x, 0, .25, 130, 55, amp: .6, decay: .07);
  normalize(x, .6);
  return x;
}

List<double> musicaFondo() {
  // Caja musical original en Do mayor, 3/4 a 96 bpm, 16 compases en bucle.
  const beat = 60 / 96;
  const melody = <List<int>>[
    [76, 79, 84], [83, 81, 76], [77, 81, 84], [83],
    [79, 84, 88], [86, 83, 79], [81, 84, 81], [79],
    [76, 81, 84], [84, 81, 77], [76, 79, 84], [86, 83, 79],
    [81, 77, 81], [83, 86, 83], [84], [79, 76, 74],
  ];
  const bass = [48, 45, 41, 43, 48, 40, 41, 43, 45, 41, 48, 43, 41, 43, 48, 48];
  final total = melody.length * 3 * beat;
  final x = buf(total + 3); // cola extra que se envuelve al inicio
  const box = [1.0, 2.0, 3.0, 4.2];
  const boxAmp = [1.0, .25, .12, .06];
  for (var bar = 0; bar < melody.length; bar++) {
    final notes = melody[bar];
    for (var k = 0; k < notes.length; k++) {
      final t = (bar * 3 + k * (3 / notes.length)) * beat;
      bell(x, t, mtof(notes[k]), amp: .5, decay: notes.length == 1 ? .7 : .4, ratios: box, amps: boxAmp);
    }
    bell(x, bar * 3 * beat, mtof(bass[bar]), amp: .35, decay: .8, ratios: const [1, 2], amps: const [1, .2]);
    bell(x, (bar * 3 + 1) * beat, mtof(bass[bar] + 19), amp: .12, decay: .3, ratios: box, amps: boxAmp);
    bell(x, (bar * 3 + 2) * beat, mtof(bass[bar] + 24), amp: .12, decay: .3, ratios: box, amps: boxAmp);
  }
  final n = (total * sr).round();
  final loop = x.sublist(0, n);
  for (var i = n; i < x.length; i++) { loop[i - n] += x[i]; }
  var m = 0.0;
  for (final v in loop) { m = max(m, v.abs()); }
  for (var i = 0; i < loop.length; i++) { loop[i] = loop[i] / m * .5; }
  return loop;
}

void main(List<String> args) {
  final dir = args.isEmpty ? 'out' : args.first;
  Directory(dir).createSync(recursive: true);
  String p(String name) => '$dir${Platform.pathSeparator}$name.wav';
  writeWav(p('esfera_guardar'), esferaGuardar());
  writeWav(p('esfera_note'), esferaTocar(784));
  writeWav(p('esfera_photo'), esferaTocar(880));
  writeWav(p('esfera_audio'), esferaTocar(659));
  writeWav(p('esfera_place'), esferaTocar(587));
  writeWav(p('esfera_heart'), esferaTocar(1047, doble: true));
  writeWav(p('esfera_goal'), esferaTocar(1319, doble: true));
  writeWav(p('saurio_tocar'), saurioTocar());
  writeWav(p('cofre_abrir'), cofreAbrir());
  writeWav(p('capsula_abrir'), capsulaAbrir());
  writeWav(p('dia_desbloquear'), diaDesbloquear());
  writeWav(p('diciembre_inicio'), diciembreInicio());
  writeWav(p('grabar_inicio'), bip(true));
  writeWav(p('grabar_fin'), bip(false));
  writeWav(p('borrar'), borrar());
  writeWav(p('musica_fondo'), musicaFondo());
}
