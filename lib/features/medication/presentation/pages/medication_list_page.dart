/// Today's Dashboard — the medication home screen.
///
/// High-contrast reminder list for the current 24-hour window.
/// Single FAB to add medication (§10.1 single primary action per screen).
/// Pull-to-refresh. Progress-oriented: adherence bar, not failure counts.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/dose_confirmation_sheet.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/medication_tile.dart';

/// Lists today's dose schedule sorted chronologically.
class MedicationListPage extends ConsumerWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(medicationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, ref, theme),
        data: (state) => _buildDashboard(context, ref, state, theme),
      ),
      // Single primary action per screen (§10.1)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/medications/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Med'),
      ),
    );
  }

  // ── Error state ──────────────────────────────────────────────────────────

  Widget _buildErrorState(
      BuildContext context, WidgetRef ref, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication,
              size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Could not load medications',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => ref.invalidate(medicationNotifierProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ── Dashboard ────────────────────────────────────────────────────────────

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    MedicationState state,
    ThemeData theme,
  ) {
    final slots = state.todaySlots;

    if (slots.isEmpty && state.medications.isEmpty) {
      return _buildEmptyState(theme);
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(medicationNotifierProvider),
      child: CustomScrollView(
        slivers: [
          // Header: date + adherence bar
          SliverToBoxAdapter(child: _buildHeader(state, theme)),

          // Dose slot list
          if (slots.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('No doses scheduled for today',
                    style: theme.textTheme.bodyLarge),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 88), // FAB clearance
              sliver: SliverList.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return MedicationTile(
                    slot: slot,
                    onTap: slot.status == DoseSlotStatus.upcoming
                        ? () => _showConfirmation(context, ref, slot)
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(MedicationState state, ThemeData theme) {
    final now = DateTime.now();
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr =
        '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    final adherence = state.adherencePercent;
    final slots = state.todaySlots;
    final taken = slots.where((s) => s.status == DoseSlotStatus.taken).length;
    final total = slots.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Today's Meds",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Adherence progress bar — progress, not perfection (§10.1)
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: total > 0 ? taken / total : 0.0,
                    minHeight: 12,
                    backgroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(
                      adherence >= 0.8
                          ? ADHDColors.taken
                          : adherence >= 0.5
                              ? ADHDColors.snoozed
                              : ADHDColors.missed,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$taken/$total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication_outlined,
              size: 80, color: theme.colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'No medications yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first medication',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dose confirmation + 5-second undo snackbar ───────────────────────────

  void _showConfirmation(
      BuildContext context, WidgetRef ref, TodayDoseSlot slot) {
    DoseConfirmationSheet.show(
      context,
      slot: slot,
      onStartConfirmation: () async {
        final notifier = ref.read(medicationNotifierProvider.notifier);
        await notifier.takeDose(
          medicationId: slot.medication.id,
          reminderId: slot.doseRecord?.reminderId ?? '',
        );
      },
      onConfirmed: () {
        // Confetti + XP shown in sheet
      },
    );
  }
}
