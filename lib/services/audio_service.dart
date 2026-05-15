import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioMemoryService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() {
    return _recorder.hasPermission();
  }

  Future<String?> startRecording() async {
    final allowed = await hasPermission();
    if (!allowed) {
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/saurio_audio');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final path =
        '${folder.path}/audio_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
    return path;
  }

  Future<String?> stopRecording() {
    return _recorder.stop();
  }

  Future<void> cancelRecording() {
    return _recorder.cancel();
  }

  Future<void> dispose() {
    return _recorder.dispose();
  }
}
