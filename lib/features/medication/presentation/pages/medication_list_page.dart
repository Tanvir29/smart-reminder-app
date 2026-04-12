/// Today's Dashboard — the medication home screen.
///
/// High-contrast grouped reminder list for the current 24-hour window.
/// Medications at the same time are grouped into a single card (§10.1).
/// Single FAB to add medication. Pull-to-refresh.
/// Progress-oriented: adherence bar, not failure counts.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/dose_confirmation_sheet.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/medications/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Med'),
      ),
    );
  }

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

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    MedicationState state,
    ThemeData theme,
  ) {
    final groups = state.todayGroups;

    if (groups.isEmpty && state.medications.isEmpty) {
      return _buildEmptyState(theme);
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(medicationNotifierProvider),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(state, theme)),
          if (groups.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('No doses scheduled for today',
                    style: theme.textTheme.bodyLarge),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 88),
              sliver: SliverList.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return _buildGroupCard(context, ref, groups[index], theme);
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

  // ── Group card ───────────────────────────────────────────────────────────

  Widget _buildGroupCard(
    BuildContext context,
    WidgetRef ref,
    GroupedDoseSlot group,
    ThemeData theme,
  ) {
    final status = group.status;
    final isActionable = status == DoseSlotStatus.upcoming ||
        status == DoseSlotStatus.partiallyTaken;
    final color = _groupColor(status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: InkWell(
        onTap: isActionable
            ? () => _showBatchConfirmation(context, ref, group)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time header row
              Row(
                children: [
                  Icon(_groupIcon(status), color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    group.formattedTime,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  if (group.count > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${group.takenCount}/${group.count}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isActionable) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Medication chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: group.slots.map((slot) {
                  final slotColor = _slotColor(slot.status, theme);
                  final lineThrough = slot.status == DoseSlotStatus.taken;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: slotColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: slotColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _medicationIcon(slot.medication.iconName),
                          size: 14,
                          color: slotColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          slot.medication.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: lineThrough
                                ? theme.colorScheme.onSurface.withOpacity(0.5)
                                : null,
                            fontWeight: FontWeight.w500,
                            decoration:
                                lineThrough ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _groupColor(DoseSlotStatus status) => switch (status) {
        DoseSlotStatus.taken => ADHDColors.taken,
        DoseSlotStatus.missed => ADHDColors.missed,
        DoseSlotStatus.upcoming => ADHDColors.upcoming,
        DoseSlotStatus.partiallyTaken => ADHDColors.snoozed,
      };

  IconData _groupIcon(DoseSlotStatus status) => switch (status) {
        DoseSlotStatus.taken => Icons.check_circle,
        DoseSlotStatus.missed => Icons.cancel,
        DoseSlotStatus.upcoming => Icons.schedule,
        DoseSlotStatus.partiallyTaken => Icons.indeterminate_check_box,
      };

  Color _slotColor(DoseSlotStatus status, ThemeData theme) => switch (status) {
        DoseSlotStatus.taken => ADHDColors.taken,
        DoseSlotStatus.missed => ADHDColors.missed,
        DoseSlotStatus.upcoming => ADHDColors.upcoming,
        DoseSlotStatus.partiallyTaken => ADHDColors.snoozed,
      };

  IconData _medicationIcon(String iconName) => switch (iconName) {
        'pill' => Icons.medication,
        'capsule' => Icons.medication_liquid,
        'injection' => Icons.vaccines,
        'inhaler' => Icons.air,
        'drops' => Icons.water_drop,
        'cream' => Icons.spa,
        _ => Icons.medication,
      };

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

  // ── Batch confirmation ───────────────────────────────────────────────────

  void _showBatchConfirmation(
      BuildContext context, WidgetRef ref, GroupedDoseSlot group) {
    DoseConfirmationSheet.show(
      context: context,
      group: group,
      onMedicationChecked: (medicationId) async {
        final notifier = ref.read(medicationNotifierProvider.notifier);
        final slot = group.slots.firstWhere(
          (s) => s.medication.id == medicationId,
        );
        await notifier.takeDose(
          medicationId: medicationId,
          reminderId: slot.doseRecord?.reminderId ?? '',
        );
      },
      onAllConfirmed: () {},
    );
  }
}
