/// Adherence dashboard showing medication compliance statistics.
///
/// Progress-oriented (§10.1): streak counters, percentage adherence,
/// trend arrows — never shows "failures."
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/adherence_chart.dart';

/// Dashboard showing medication adherence analytics.
class AdherenceDashboardPage extends ConsumerWidget {
  const AdherenceDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(medicationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Adherence')),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) => _buildContent(state, theme),
      ),
    );
  }

  Widget _buildContent(MedicationState state, ThemeData theme) {
    final slots = state.todaySlots;
    final taken = slots.where((s) => s.status == DoseSlotStatus.taken).length;
    final missed = slots.where((s) => s.status == DoseSlotStatus.missed).length;
    final upcoming =
        slots.where((s) => s.status == DoseSlotStatus.upcoming).length;
    final adherence = state.adherencePercent;
    final pct = (adherence * 100).round();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Big adherence ring ──────────────────────────────────────────
        Center(
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: adherence,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                    adherence >= 0.8
                        ? ADHDColors.taken
                        : adherence >= 0.5
                            ? ADHDColors.snoozed
                            : ADHDColors.missed,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pct%',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Today',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Stat cards ──────────────────────────────────────────────────
        Row(
          children: [
            _StatCard(
              icon: Icons.check_circle,
              color: ADHDColors.taken,
              value: '$taken',
              label: 'Taken',
              theme: theme,
            ),
            const SizedBox(width: 8),
            _StatCard(
              icon: Icons.event_note,
              color: ADHDColors.neutral,
              value: '${taken + missed + upcoming}',
              label: 'Total',
              theme: theme,
            ),
            const SizedBox(width: 8),
            _StatCard(
              icon: Icons.schedule,
              color: ADHDColors.upcoming,
              value: '$upcoming',
              label: 'Upcoming',
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Weekly chart placeholder ────────────────────────────────────
        Text('This Week',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdherenceChart(
          weeklyAdherence: _computeWeeklyAdherence(state),
        ),
      ],
    );
  }

  List<double> _computeWeeklyAdherence(MedicationState state) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weeklyAdherence = List<double>.filled(7, 0.0);

    for (int i = 0; i < 7; i++) {
      final dayOffset = 6 - i;
      final dayStart = today.subtract(Duration(days: dayOffset));
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayStartMs = dayStart.millisecondsSinceEpoch;
      final dayEndMs = dayEnd.millisecondsSinceEpoch;

      final dayDoses = state.weeklyDoses.where((dose) {
        return dose.scheduledTime >= dayStartMs &&
            dose.scheduledTime < dayEndMs;
      }).toList();

      if (dayDoses.isEmpty && dayOffset > 0) {
        continue;
      }

      final taken = dayDoses.where((d) => d.status == DoseStatus.taken).length;
      final total = dayDoses.length;

      if (total > 0) {
        weeklyAdherence[i] = taken / total;
      } else if (dayOffset == 0) {
        weeklyAdherence[i] = state.adherencePercent;
      }
    }

    return weeklyAdherence;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
