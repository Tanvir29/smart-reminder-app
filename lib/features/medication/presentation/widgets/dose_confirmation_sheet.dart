/// Smart modal bottom sheet for batch dose confirmation.
///
/// Displays a **checklist** (not a "Take All" button) per §10.1.
/// ADHD users often log all meds as 'taken' even if they only swallowed
/// one. Force a per-item check with haptic pulse per checkmark.
///
/// Flow:
/// 1. Shows list of medications due at the same time.
/// 2. User checks off each medication individually.
/// 3. Swipe-to-confirm or tap-3× challenge (if any critical med) to
///    finalize.
/// 4. Confetti + XP popup on completion.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/confetti_overlay.dart';

class _CheckItem {
  final TodayDoseSlot slot;
  bool checked;

  _CheckItem({required this.slot, this.checked = false});
}

/// Modal bottom sheet for batch dose confirmation with per-item checklist.
class DoseConfirmationSheet extends ConsumerStatefulWidget {
  final GroupedDoseSlot group;
  final void Function(String medicationId)? onMedicationChecked;
  final void Function()? onAllConfirmed;

  const DoseConfirmationSheet({
    super.key,
    required this.group,
    this.onMedicationChecked,
    this.onAllConfirmed,
  });

  /// Shows a single-medication confirmation (backward-compatible).
  static Future<void> showSingle(
    BuildContext context, {
    required TodayDoseSlot slot,
    void Function()? onStartConfirmation,
    void Function()? onConfirmed,
  }) {
    final group = GroupedDoseSlot.fromSlots([slot]);
    return show(
      context: context,
      group: group,
      onMedicationChecked: (_) async {
        onStartConfirmation?.call();
      },
      onAllConfirmed: onConfirmed,
    );
  }

  /// Shows a batch confirmation sheet for a [GroupedDoseSlot].
  static Future<void> show({
    required BuildContext context,
    required GroupedDoseSlot group,
    void Function(String medicationId)? onMedicationChecked,
    void Function()? onAllConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoseConfirmationSheet(
        group: group,
        onMedicationChecked: onMedicationChecked,
        onAllConfirmed: onAllConfirmed,
      ),
    );
  }

  @override
  ConsumerState<DoseConfirmationSheet> createState() =>
      _DoseConfirmationSheetState();
}

class _DoseConfirmationSheetState extends ConsumerState<DoseConfirmationSheet> {
  late final List<_CheckItem> _items;
  bool _finalized = false;
  bool _showConfetti = false;
  bool _finalizationStarted = false;
  Timer? _finalizationTimer;

  // Tap-3× challenge state
  int _tapCount = 0;

  // Swipe-to-confirm state
  double _swipeProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _items = widget.group.slots
        .where((s) => s.status == DoseSlotStatus.upcoming)
        .map((s) => _CheckItem(slot: s))
        .toList();
  }

  @override
  void dispose() {
    _finalizationTimer?.cancel();
    super.dispose();
  }

  bool get _allChecked => _items.isNotEmpty && _items.every((i) => i.checked);
  int get _checkedCount => _items.where((i) => i.checked).length;
  bool get _hasCritical => _items.any((i) => i.slot.isCritical);

  void _onCheckItem(int index) {
    if (_finalized) return;
    setState(() {
      _items[index].checked = !_items[index].checked;
    });
    HapticFeedback.lightImpact();
    widget.onMedicationChecked?.call(_items[index].slot.medication.id);
  }

  Future<void> _startFinalization() async {
    final reminderId = widget.group.reminderId;
    if (reminderId == null || reminderId.isEmpty) {
      _startInteractionProof();
      return;
    }

    try {
      final confirmReminder = ref.read(confirmReminderProvider);
      await confirmReminder.call(reminderId);
      _startInteractionProof();
    } catch (e) {
      if (widget.group.reminderId == null || widget.group.reminderId!.isEmpty) {
        _startInteractionProof();
        return;
      }
      rethrow;
    }
  }

  void _startInteractionProof() {
    setState(() {
      _finalizationStarted = true;
    });
    _finalizationTimer = Timer(const Duration(seconds: 30), () {
      if (mounted && !_finalized) {
        _onFinalizationTimeout();
      }
    });
  }

  void _onFinalizationTimeout() {
    _finalizationTimer?.cancel();
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirmation timed out. Please try again.'),
        ),
      );
    }
  }

  Future<void> _onFinalized() async {
    if (_finalized) return;
    setState(() {
      _finalized = true;
      _showConfetti = true;
    });
    HapticFeedback.vibrate();
    _finalizationTimer?.cancel();

    final reminderId = widget.group.reminderId;
    if (reminderId != null && reminderId.isNotEmpty) {
      try {
        final finalizeConfirmation = ref.read(finalizeConfirmationProvider);
        await finalizeConfirmation.call(reminderId);
      } catch (_) {}
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onAllConfirmed?.call();
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
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
                const SizedBox(height: 20),

                // Time header
                Text(
                  widget.group.formattedTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: ADHDColors.upcoming,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.group.count} medication${widget.group.count != 1 ? 's' : ''} due',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                if (_finalized)
                  _buildFinalizedState(theme)
                else ...[
                  _buildChecklist(theme),
                  const SizedBox(height: 20),
                  _buildFinalizeAction(theme),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
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

  // ── Checklist ──────────────────────────────────────────────────────────

  Widget _buildChecklist(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        final med = item.slot.medication;
        final isChecked = item.checked;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () => _onCheckItem(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isChecked
                      ? ADHDColors.taken.withOpacity(0.6)
                      : theme.colorScheme.onSurface.withOpacity(0.15),
                  width: 1.5,
                ),
                color: isChecked
                    ? ADHDColors.taken.withOpacity(0.08)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  // Checkbox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? ADHDColors.taken : Colors.transparent,
                      border: Border.all(
                        color: isChecked
                            ? ADHDColors.taken
                            : theme.colorScheme.onSurface.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Medication info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                            color: isChecked
                                ? theme.colorScheme.onSurface.withOpacity(0.5)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          med.dosage,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Critical badge
                  if (med.isCritical)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ADHDColors.missed.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CRITICAL',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: ADHDColors.missed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Finalize action ────────────────────────────────────────────────────

  Widget _buildFinalizeAction(ThemeData theme) {
    // Not all checked yet — show progress
    if (!_allChecked) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _items.isEmpty ? 0 : _checkedCount / _items.length,
              minHeight: 8,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(ADHDColors.upcoming),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_checkedCount of ${_items.length} checked',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      );
    }

    // All checked — show confirmation mechanism
    if (!_finalizationStarted) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: _startFinalization,
          style: FilledButton.styleFrom(
            backgroundColor: ADHDColors.taken,
          ),
          icon: const Icon(Icons.check_circle_outline, size: 24),
          label: const Text(
            'Confirm All',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    if (_hasCritical) {
      return _buildTap3xChallenge(theme);
    }
    return _buildSwipeToConfirm(theme);
  }

  // ── Finalized state ────────────────────────────────────────────────────

  Widget _buildFinalizedState(ThemeData theme) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: ADHDColors.taken, size: 64),
        const SizedBox(height: 8),
        Text(
          'All ${_items.length} medication${_items.length != 1 ? 's' : ''} confirmed!',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '+${_items.length * 10} XP',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: ADHDColors.xpBar,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Tap 3× challenge ───────────────────────────────────────────────────

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
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () {
              setState(() => _tapCount++);
              HapticFeedback.lightImpact();
              if (_tapCount >= 3) _onFinalized();
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
              'Confirm All ($_tapCount/3)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
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

  // ── Swipe-to-confirm slider ────────────────────────────────────────────

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
                  _onFinalized();
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
