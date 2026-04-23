/// Weekly adherence chart using CustomPainter.
///
/// ADHD-friendly minimal design — color-coded bars, no axis clutter.
/// Uses [ADHDColors] for taken/missed status coloring.
library;

import 'package:flutter/material.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';

/// Renders a simple 7-day bar chart for weekly adherence.
///
/// Accepts [weeklyAdherence] values (0.0-1.0) for each day of the week.
/// Values <= 0 are treated as "no data yet."
class AdherenceChart extends StatelessWidget {
  final List<double> weeklyAdherence;

  const AdherenceChart({
    super.key,
    required this.weeklyAdherence,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final values = weeklyAdherence;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final value = values[i];
              final hasData = value > 0;
              final color = !hasData
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                  : value >= 0.8
                      ? ADHDColors.taken
                      : value >= 0.5
                          ? ADHDColors.snoozed
                          : ADHDColors.missed;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (hasData)
                        Text(
                          '${(value * 100).round()}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: hasData ? value.clamp(0.1, 1.0) : 0.1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[i],
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
