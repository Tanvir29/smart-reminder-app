/// Add Medication Page — single scrollable form (NO wizard, NO multi-step).
///
/// Per §10.1: one primary action per screen (the Save button).
/// Fields: Name, Dosage, Frequency, Time picker, isCritical toggle.
/// Calls [MedicationNotifier.addMedication] via ref — zero logic in widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:uuid/uuid.dart';

/// Single scrollable form to add a new medication.
class AddMedicationPage extends ConsumerStatefulWidget {
  const AddMedicationPage({super.key});

  @override
  ConsumerState<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends ConsumerState<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _reminderMessageController = TextEditingController();

  String _frequencyType = 'daily';
  List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];
  List<int> _weekDays = [1, 2, 3, 4, 5]; // Mon–Fri default
  int _intervalHours = 8;
  bool _isCritical = false;
  bool _saving = false;

  // Reminder Duration state
  String _durationType =
      'fixedDays'; // 'fixedDays', 'oneMonth', 'continuous', 'custom'
  String _customUnit = 'days'; // 'days', 'weeks', 'months'
  int _customValue = 7;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    _reminderMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Medication')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Name ────────────────────────────────────────────────────
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                prefixIcon: Icon(Icons.medication),
                hintText: 'e.g. Ibuprofen',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // ── Dosage ──────────────────────────────────────────────────
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage',
                prefixIcon: Icon(Icons.science),
                hintText: 'e.g. 200mg',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            // ── Frequency type ──────────────────────────────────────────
            Text(
              'Frequency',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'daily',
                  label: Text('Daily'),
                  icon: Icon(Icons.calendar_today, size: 18),
                ),
                ButtonSegment(
                  value: 'weekly',
                  label: Text('Weekly'),
                  icon: Icon(Icons.calendar_view_week, size: 18),
                ),
                ButtonSegment(
                  value: 'interval',
                  label: Text('Interval'),
                  icon: Icon(Icons.timer, size: 18),
                ),
                ButtonSegment(
                  value: 'oneTime',
                  label: Text('One-time'),
                  icon: Icon(Icons.event, size: 18),
                ),
              ],
              selected: {_frequencyType},
              onSelectionChanged: (s) =>
                  setState(() => _frequencyType = s.first),
            ),
            const SizedBox(height: 16),

            // ── Frequency-specific options ──────────────────────────────
            if (_frequencyType == 'daily' || _frequencyType == 'weekly')
              _buildTimePickers(theme),
            if (_frequencyType == 'weekly') _buildWeekDayPicker(theme),
            if (_frequencyType == 'interval') _buildIntervalPicker(theme),
            if (_frequencyType == 'oneTime') _buildOneTimePicker(theme),
            const SizedBox(height: 16),

            // ── Instructions ────────────────────────────────────────────
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions (optional)',
                prefixIcon: Icon(Icons.info_outline),
                hintText: 'e.g. Take with food',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // ── Custom Voice Message ─────────────────────────────────────
            TextFormField(
              controller: _reminderMessageController,
              decoration: const InputDecoration(
                labelText: 'Custom Voice Message (optional)',
                prefixIcon: Icon(Icons.record_voice_over),
                hintText: 'e.g. Take with food, not with coffee',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // ── Critical toggle ─────────────────────────────────────────
            Card(
              child: SwitchListTile(
                title: const Text('Critical Medication'),
                subtitle: const Text('Requires triple-tap to confirm dose'),
                secondary: Icon(
                  Icons.warning_amber,
                  color: _isCritical ? ADHDColors.missed : null,
                ),
                value: _isCritical,
                onChanged: (v) => setState(() => _isCritical = v),
              ),
            ),
            const SizedBox(height: 16),

            // ── Reminder Duration ───────────────────────────────────────
            Text(
              'Reminder Duration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'fixedDays',
                  label: Text('7 Days'),
                  icon: Icon(Icons.calendar_view_week, size: 18),
                ),
                ButtonSegment(
                  value: 'oneMonth',
                  label: Text('1 Month'),
                  icon: Icon(Icons.calendar_month, size: 18),
                ),
                ButtonSegment(
                  value: 'continuous',
                  label: Text('Ongoing'),
                  icon: Icon(Icons.all_inclusive, size: 18),
                ),
                ButtonSegment(
                  value: 'custom',
                  label: Text('Custom'),
                  icon: Icon(Icons.tune, size: 18),
                ),
              ],
              selected: {_durationType},
              onSelectionChanged: (s) =>
                  setState(() => _durationType = s.first),
            ),

            // Custom duration input
            if (_durationType == 'custom') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _customValue.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Duration',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        final parsed = int.tryParse(v);
                        if (parsed != null && parsed > 0) {
                          setState(() => _customValue = parsed);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _customUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: const [
                        DropdownMenuItem(value: 'days', child: Text('Days')),
                        DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                        DropdownMenuItem(
                          value: 'months',
                          child: Text('Months'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _customUnit = v);
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),

            // ── Save button (single primary action — §10.1) ─────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(_saving ? 'Saving...' : 'Save Medication'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Time pickers ─────────────────────────────────────────────────────────

  Widget _buildTimePickers(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Times', style: theme.textTheme.bodyLarge),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setState(
                () => _times.add(const TimeOfDay(hour: 12, minute: 0)),
              ),
            ),
          ],
        ),
        ...List.generate(_times.length, (i) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time, color: ADHDColors.upcoming),
            title: Text(
              _times[i].format(context),
              style: theme.textTheme.titleMedium,
            ),
            trailing: _times.length > 1
                ? IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: ADHDColors.missed,
                    onPressed: () => setState(() => _times.removeAt(i)),
                  )
                : null,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _times[i],
              );
              if (picked != null) setState(() => _times[i] = picked);
            },
          );
        }),
      ],
    );
  }

  // ── Week-day picker ──────────────────────────────────────────────────────

  Widget _buildWeekDayPicker(ThemeData theme) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Days of Week', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final day = i + 1; // 1=Monday (ISO 8601)
            final selected = _weekDays.contains(day);
            return GestureDetector(
              onTap: () => setState(() {
                selected ? _weekDays.remove(day) : _weekDays.add(day);
              }),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: selected
                    ? ADHDColors.upcoming
                    : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color:
                        selected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Interval picker ──────────────────────────────────────────────────────

  Widget _buildIntervalPicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Every $_intervalHours hours', style: theme.textTheme.bodyLarge),
        Slider(
          value: _intervalHours.toDouble(),
          min: 1,
          max: 24,
          divisions: 23,
          label: '$_intervalHours hours',
          onChanged: (v) => setState(() => _intervalHours = v.round()),
        ),
      ],
    );
  }

  // ── One-time picker ──────────────────────────────────────────────────────

  Widget _buildOneTimePicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select reminder time', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: _times.isNotEmpty ? _times.first : TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => _times = [picked]);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  _times.isNotEmpty
                      ? '${_times.first.hour.toString().padLeft(2, '0')}:${_times.first.minute.toString().padLeft(2, '0')}'
                      : 'Select time',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Custom duration helper ─────────────────────────────────────────────

  DateTime _addMonths(DateTime date, int months) {
    final targetMonth = date.month + months;
    final targetYear = date.year + (targetMonth - 1) ~/ 12;
    final normalizedMonth = ((targetMonth - 1) % 12) + 1;
    final lastDayOfMonth = DateTime(targetYear, normalizedMonth + 1, 0).day;
    final clampedDay = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
    return DateTime(targetYear, normalizedMonth, clampedDay);
  }

  ReminderDuration _buildCustomDuration() {
    final now = DateTime.now();
    DateTime endDate;

    switch (_customUnit) {
      case 'weeks':
        endDate = now.add(Duration(days: _customValue * 7));
        break;
      case 'months':
        endDate = _addMonths(now, _customValue);
        break;
      case 'days':
      default:
        endDate = now.add(Duration(days: _customValue));
        break;
    }

    return ReminderDuration.custom(endTime: endDate.millisecondsSinceEpoch);
  }

  // ── Save action ──────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_frequencyType == 'weekly' && _weekDays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select at least one day')));
      return;
    }

    setState(() => _saving = true);

    final timesMinutes = _times.map((t) => t.hour * 60 + t.minute).toList()
      ..sort();

    final frequency = switch (_frequencyType) {
      'daily' => MedicationFrequency.daily(timesOfDay: timesMinutes),
      'weekly' => MedicationFrequency.weekly(
          timesOfDay: timesMinutes,
          weekDays: _weekDays..sort(),
        ),
      'interval' => MedicationFrequency.interval(intervalHours: _intervalHours),
      'oneTime' => MedicationFrequency.oneTime(
          scheduledTimeMinutes:
              timesMinutes.isNotEmpty ? timesMinutes.first : 480,
        ),
      _ => MedicationFrequency.daily(timesOfDay: timesMinutes),
    };

    final reminderDuration = switch (_durationType) {
      'fixedDays' => const ReminderDuration.fixedDays(days: 7),
      'oneMonth' => const ReminderDuration.oneMonth(),
      'continuous' => const ReminderDuration.continuous(),
      'custom' => _buildCustomDuration(),
      _ => const ReminderDuration.fixedDays(days: 7),
    };

    final now = DateTime.now().millisecondsSinceEpoch;
    final medication = Medication(
      id: const Uuid().v4(),
      profileId: 'default',
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      frequency: frequency,
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
      reminderMessage: _reminderMessageController.text.trim().isEmpty
          ? null
          : _reminderMessageController.text.trim(),
      reminderDuration: reminderDuration,
      isCritical: _isCritical,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await ref
          .read(medicationNotifierProvider.notifier)
          .addMedication(medication);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    }
  }
}
