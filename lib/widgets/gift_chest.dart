import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GiftChest extends StatefulWidget {
  const GiftChest({super.key, required this.capsules, required this.onTap});

  final int capsules;
  final VoidCallback onTap;

  @override
  State<GiftChest> createState() => _GiftChestState();
}

class _GiftChestState extends State<GiftChest> with TickerProviderStateMixin {
  static const _closedAsset = 'assets/chest/cofre.png';
  static const _openAsset = 'assets/chest/cofre_abierto.png';
  static const _size = Size(150, 96);

  late final AnimationController _idle;
  late final AnimationController _open;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _open = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _idle.dispose();
    _open.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    widget.onTap();
    await _open.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) await _open.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_idle, _open]),
        builder: (context, _) {
          final idle = Curves.easeInOut.transform(_idle.value);
          final floatY = -idle * 4; // flota suave hacia arriba
          final open = _open.value;
          final pop = sin(open * pi); // 0 → 1 → 0
          final scale = 1 + pop * 0.06;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                width: _size.width,
                height: _size.height,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Brillo al abrir
                    Opacity(
                      opacity: pop * 0.9,
                      child: Container(
                        width: _size.width * 0.7,
                        height: _size.height * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFFE9B0).withValues(alpha: 0.9),
                              const Color(0x00FFE9B0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Cofre cerrado
                    Opacity(
                      opacity: 1 - Curves.easeOut.transform(open),
                      child: _chestImage(_closedAsset),
                    ),
                    // Cofre abierto (cae a cerrado si el asset no existe)
                    Opacity(
                      opacity: Curves.easeOut.transform(open),
                      child: _chestImage(_openAsset, fallbackToClosed: true),
                    ),
                    if (widget.capsules > 0)
                      Positioned(
                        top: 2,
                        right: 6,
                        child: _CapsuleBadge(count: widget.capsules),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chestImage(String asset, {bool fallbackToClosed = false}) {
    return Image.asset(
      asset,
      width: _size.width,
      height: _size.height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        if (fallbackToClosed) {
          return Image.asset(
            _closedAsset,
            width: _size.width,
            height: _size.height,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _placeholder(),
          );
        }
        return _placeholder();
      },
    );
  }

  // Marcador temporal mientras no existan los PNG del cofre.
  Widget _placeholder() {
    return Container(
      width: _size.width,
      height: _size.height * 0.75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF7A2F2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0C073), width: 2),
      ),
      child: const Text(
        'cofre.png',
        style: TextStyle(color: Color(0xFFFFE0A1), fontSize: 12),
      ),
    );
  }
}

class _CapsuleBadge extends StatelessWidget {
  const _CapsuleBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE0C073),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0x55000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Color(0xFF17130A),
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}
