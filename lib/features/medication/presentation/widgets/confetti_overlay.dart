/// Confetti burst overlay for dose confirmation celebration.
///
/// Uses [CustomPainter] per spec §10.1 — no external packages.
/// The [ADHDColors.reward] color (#FFD600) is the primary confetti color,
/// used sparingly to avoid habituation (§10.2 note).
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';

/// A 300ms confetti burst animation.
///
/// Insert this widget into a [Stack] after dose confirmation.
/// It auto-plays on mount and calls [onComplete] when finished.
class ConfettiOverlay extends StatefulWidget {
  /// Called when the 300ms animation completes.
  final VoidCallback? onComplete;

  const ConfettiOverlay({super.key, this.onComplete});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const _count = 40;
  static const _duration = Duration(milliseconds: 300);
  static const _colors = [
    ADHDColors.reward,
    ADHDColors.reward,
    ADHDColors.taken,
    ADHDColors.xpBar,
    Colors.white,
    ADHDColors.streakActive,
    ADHDColors.achievementGold,
  ];

  @override
  void initState() {
    super.initState();
    final rng = Random();

    _particles = List.generate(_count, (_) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 80 + rng.nextDouble() * 180;
      return _Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 120, // bias upward
        size: 4 + rng.nextDouble() * 5,
        color: _colors[rng.nextInt(_colors.length)],
        rotation: rng.nextDouble() * 2 * pi,
        rotationSpeed: (rng.nextDouble() - 0.5) * 12,
        isRect: rng.nextBool(),
      );
    });

    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Internal models
// ──────────────────────────────────────────────────────────────────────────────

class _Particle {
  final double vx;
  final double vy;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final bool isRect;

  const _Particle({
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.isRect,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.45; // slightly above center
    final t = progress;
    final opacity = (1.0 - t).clamp(0.0, 1.0);

    for (final p in particles) {
      final x = cx + p.vx * t;
      final y = cy + p.vy * t + 300 * t * t; // gravity pull

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.rotationSpeed * t);

      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
