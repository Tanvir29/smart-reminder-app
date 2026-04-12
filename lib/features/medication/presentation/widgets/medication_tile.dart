/// Status-colored tile for a single dose slot in the Today's Dashboard.
///
/// Color-coded per ADHD-Friendly UX Contract §10.2:
/// - Green (#2E7D32) = taken
/// - Red (#C62828) = missed
/// - Blue (#1565C0) = upcoming
///
/// Tapping an upcoming slot triggers [onTap] to open dose confirmation.
/// Minimal text, maximum icons (§10.1).
library;

import 'package:flutter/material.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';

/// Displays a single dose slot with medication info and status indicator.
class MedicationTile extends StatelessWidget {
  final TodayDoseSlot slot;
  final VoidCallback? onTap;

  const MedicationTile({
    super.key,
    required this.slot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor;
    final isActionable = slot.status == DoseSlotStatus.upcoming;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: InkWell(
        onTap: isActionable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Status dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Medication icon
              Icon(_medicationIcon, color: color, size: 28),
              const SizedBox(width: 12),

              // Name + dosage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.medication.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: slot.status == DoseSlotStatus.taken
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      slot.medication.dosage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Time + status icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    slot.formattedTime,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(_statusIcon, color: color, size: 20),
                ],
              ),

              // Chevron for actionable slots
              if (isActionable) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color get _statusColor => switch (slot.status) {
        DoseSlotStatus.taken => ADHDColors.taken,
        DoseSlotStatus.missed => ADHDColors.missed,
        DoseSlotStatus.upcoming => ADHDColors.upcoming,
        DoseSlotStatus.partiallyTaken => ADHDColors.snoozed,
      };

  IconData get _statusIcon => switch (slot.status) {
        DoseSlotStatus.taken => Icons.check_circle,
        DoseSlotStatus.missed => Icons.cancel,
        DoseSlotStatus.upcoming => Icons.schedule,
        DoseSlotStatus.partiallyTaken => Icons.indeterminate_check_box,
      };

  IconData get _medicationIcon => switch (slot.medication.iconName) {
        'pill' => Icons.medication,
        'capsule' => Icons.medication_liquid,
        'injection' => Icons.vaccines,
        'inhaler' => Icons.air,
        'drops' => Icons.water_drop,
        'cream' => Icons.spa,
        _ => Icons.medication,
      };
}
