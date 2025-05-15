import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/features/waste_stats/frontend/views/summary_view_content.dart';
import '../../../../core/models/scan_result_model.dart';
import '../../../../core/services/waste_entry_service.dart';
import '../../../../core/utils/constants.dart';


class SummaryView extends StatelessWidget {
  final WasteEntryService service = WasteEntryService();

  final bool updateView;
  final VoidCallback onFirstView;
  final VoidCallback onSecondView;
  final String firstViewTitle;
  final String secondViewTitle;

  SummaryView({
    super.key,
    required this.updateView,
    required this.onFirstView,
    required this.onSecondView,
    required this.firstViewTitle,
    required this.secondViewTitle,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: service.fetchWasteEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: kAvocado));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \${snapshot.error}'));
        }

        final entries = snapshot.data ?? [];
        final validEntries = entries.where((e) => e.timestamp != null && e.qty != null).toList();

        final wasteCount = validEntries.fold<int>(0, (sum, entry) => sum + (entry.qty ?? 0));

        final Map<String, int> classificationCounts = {
          'Recyclable': 0,
          'Biodegradable': 0,
          'Non-biodegradable': 0,
        };

        for (final entry in validEntries) {
          final classification = entry.classification ?? '';
          if (classificationCounts.containsKey(classification)) {
            classificationCounts[classification] = classificationCounts[classification]! + 1;
          }
        }

        List<FlSpot> spots;

        if (updateView) {

          // wekely view (Mon=1 to Sun=7)
          final Map<int, int> qtyPerDay = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
          for (final entry in validEntries) {
            final weekday = entry.timestamp!.weekday;
            qtyPerDay[weekday] = qtyPerDay[weekday]! + (entry.qty ?? 0);
          }
          spots = qtyPerDay.entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
              .toList();
        } else {

          // monthly view (last 5 months + including current)
          final now = DateTime.now();
          final List<DateTime> months = List.generate(5, (i) {
            final date = DateTime(now.year, now.month - 4 + i);
            return DateTime(date.year, date.month);
          });

          final Map<int, int> qtyPerMonth = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

          for (final entry in validEntries) {
            final ts = entry.timestamp!;
            for (int i = 0; i < months.length; i++) {
              final monthStart = months[i];
              final monthEnd = DateTime(monthStart.year, monthStart.month + 1);
              if (ts.isAfter(monthStart.subtract(const Duration(days: 1))) && ts.isBefore(monthEnd)) {
                qtyPerMonth[i + 1] = qtyPerMonth[i + 1]! + (entry.qty ?? 0);
                break;
              }
            }
          }

          spots = qtyPerMonth.entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
              .toList();
        }

        return SummaryViewContent(
          wasteCount: wasteCount,
          updateView: updateView,
          onFirstView: onFirstView,
          onSecondView: onSecondView,
          firstViewTitle: firstViewTitle,
          secondViewTitle: secondViewTitle,
          classificationCounts: classificationCounts,
          spots: spots,
        );
      },
    );
  }
}


