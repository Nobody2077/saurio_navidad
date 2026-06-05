import 'package:flutter/material.dart';

enum SaurioMood { cozy, excited, recording, photo, surprise }

class SaurioMascot extends StatelessWidget {
  const SaurioMascot({super.key, required this.mood});

  final SaurioMood mood;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetForMood(mood),
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}

String _assetForMood(SaurioMood mood) {
  switch (mood) {
    case SaurioMood.cozy:
      return 'assets/saurio/cozy/saurio.png';
    case SaurioMood.excited:
      return 'assets/saurio/excited/saurio.png';
    case SaurioMood.recording:
      return 'assets/saurio/recording/saurio.png';
    case SaurioMood.photo:
      return 'assets/saurio/photo/saurio.png';
    case SaurioMood.surprise:
      return 'assets/saurio/surprise/saurio.png';
  }
}
