import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveSaurioMascot extends StatelessWidget {
  const RiveSaurioMascot({
    super.key,
    this.asset = 'assets/rive/saurio.riv',
    this.artboard = 'Saurio',
    this.stateMachine = 'SaurioMachine',
  });

  final String asset;
  final String artboard;
  final String stateMachine;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      asset,
      artboard: artboard,
      stateMachines: [stateMachine],
      fit: BoxFit.contain,
    );
  }
}
