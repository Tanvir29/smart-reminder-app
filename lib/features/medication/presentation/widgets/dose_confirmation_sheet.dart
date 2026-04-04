/// Smart modal bottom sheet for confirming a dose was taken.
///
/// Dynamic confirmation modes per §5.5:
/// - Default medications: Swipe-to-confirm slider
/// - Critical medications (isCritical=true): Tap 3× challenge
///
/// On success: [HapticFeedback.vibrate] + 300ms confetti + XP popup (§10.1).
/// Undo-over-confirm: no "Are you sure?" — immediate action with undo toast.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/confetti_overlay.dart';

/// Modal bottom sheet for dose confirmation with haptic + confetti reward.
class DoseConfirmationSheet extends StatefulWidget {
  final TodayDoseSlot slot;
  final VoidCallback onConfirmed;

  const DoseConfirmationSheet({
    super.key,
    required this.slot,
    required this.onConfirmed,
  });

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required TodayDoseSlot slot,
    required VoidCallback onConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoseConfirmationSheet(
        slot: slot,
        onConfirmed: onConfirmed,
      ),
    );
  }

  @override
  State<DoseConfirmationSheet> createState() => _DoseConfirmationSheetState();
}

class _DoseConfirmationSheetState extends State<DoseConfirmationSheet> {
  bool _confirmed = false;
  bool _showConfetti = false;

  // Tap-3× challenge state
  int _tapCount = 0;

  // Swipe-to-confirm state
  double _swipeProgress = 0.0;

  void _onConfirmed() {
    if (_confirmed) return;
    setState(() {
      _confirmed = true;
      _showConfetti = true;
    });
    HapticFeedback.vibrate();

    // Let confetti play (300ms per spec §10.1), then dismiss and fire callback
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onConfirmed();
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final med = widget.slot.medication;

    return Stack(
      children: [
        // Sheet body
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // Medication icon
                Icon(Icons.medication, size: 48, color: ADHDColors.upcoming),
                const SizedBox(height: 16),

                // Medication name
                Text(
                  med.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Dosage
                Text(
                  med.dosage,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),

                // Scheduled time
                Text(
                  widget.slot.formattedTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: ADHDColors.upcoming,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                // Confirmation mode
                if (_confirmed)
                  _buildConfirmedState(theme)
                else if (widget.slot.isCritical)
                  _buildTap3xChallenge(theme)
                else
                  _buildSwipeToConfirm(theme),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Confetti overlay (full-sheet)
        if (_showConfetti)
          Positioned.fill(
            child: ConfettiOverlay(
              onComplete: () {
                if (mounted) setState(() => _showConfetti = false);
              },
            ),
          ),
      ],
    );
  }

  // ── Confirmed state ──────────────────────────────────────────────────────

  Widget _buildConfirmedState(ThemeData theme) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: ADHDColors.taken, size: 64),
        const SizedBox(height: 8),
        Text(
          '+${widget.slot.medication.xpValue} XP',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: ADHDColors.xpBar,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Tap 3× challenge (§5.5 interactionChallenge) ─────────────────────────

  Widget _buildTap3xChallenge(ThemeData theme) {
    final remaining = 3 - _tapCount;

    return Column(
      children: [
        Text(
          'Critical Medication',
          style: theme.textTheme.labelLarge?.copyWith(
            color: ADHDColors.missed,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap $remaining more time${remaining != 1 ? 's' : ''} to confirm',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        // Tap button with intensifying color
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () {
              setState(() => _tapCount++);
              HapticFeedback.lightImpact();
              if (_tapCount >= 3) _onConfirmed();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Color.lerp(
                ADHDColors.missed.withOpacity(0.6),
                ADHDColors.taken,
                _tapCount / 3,
              ),
            ),
            icon: const Icon(Icons.touch_app, size: 24),
            label: Text(
              'Confirm Dose ($_tapCount/3)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _tapCount
                    ? ADHDColors.taken
                    : theme.colorScheme.onSurface.withOpacity(0.2),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Swipe-to-confirm slider (§5.5 swipeToConfirm) ────────────────────────

  Widget _buildSwipeToConfirm(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Swipe to confirm',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            const thumbSize = 56.0;
            final maxDrag = trackWidth - thumbSize;

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _swipeProgress =
                      ((_swipeProgress * maxDrag + details.delta.dx) / maxDrag)
                          .clamp(0.0, 1.0);
                });
              },
              onHorizontalDragEnd: (_) {
                if (_swipeProgress > 0.85) {
                  _onConfirmed();
                } else {
                  setState(() => _swipeProgress = 0.0);
                }
              },
              child: Container(
                height: thumbSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(thumbSize / 2),
                  color: Color.lerp(
                    theme.colorScheme.onSurface.withOpacity(0.1),
                    ADHDColors.taken.withOpacity(0.2),
                    _swipeProgress,
                  ),
                ),
                child: Stack(
                  children: [
                    // Green fill behind thumb
                    FractionallySizedBox(
                      widthFactor: (_swipeProgress + thumbSize / trackWidth)
                          .clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(thumbSize / 2),
                          color: ADHDColors.taken.withOpacity(0.25),
                        ),
                      ),
                    ),
                    // Chevron hints (fade out as user swipes)
                    Center(
                      child: Opacity(
                        opacity: (1.0 - _swipeProgress * 2).clamp(0.0, 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chevron_right,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3)),
                            Icon(Icons.chevron_right,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.2)),
                            Icon(Icons.chevron_right,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.1)),
                          ],
                        ),
                      ),
                    ),
                    // Draggable thumb
                    Positioned(
                      left: _swipeProgress * maxDrag,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.lerp(ADHDColors.upcoming,
                              ADHDColors.taken, _swipeProgress),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _swipeProgress > 0.85
                              ? Icons.check
                              : Icons.chevron_right,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
