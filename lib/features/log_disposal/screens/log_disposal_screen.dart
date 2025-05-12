import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/search_bar/search_bar.dart';
import 'package:trashtrackr/core/widgets/text_fields/search_bar/filter_modal.dart';

class LogDisposalScreen extends StatefulWidget {
  const LogDisposalScreen({super.key});

  @override
  State<LogDisposalScreen> createState() => _LogDisposalScreenState();
}

class _LogDisposalScreenState extends State<LogDisposalScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';
  DateTimeRange? selectedDateRange;
  String? selectedWasteType;
  final List<String> multiSelectOptions = [];

   final List<LogEntry> logEntries = logEntry;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return FilterModal(
          initialWasteType: selectedWasteType,
          initialDateRange: selectedDateRange,
          initialMultiSelect: multiSelectOptions,
          onApply: (String? wasteType, DateTimeRange? dateRange, List<String> quickFilters) {
            Navigator.of(modalContext).pop(); // Close the modal
            setState(() {
              selectedWasteType = wasteType;
              selectedDateRange = dateRange;
              multiSelectOptions
                ..clear()
                ..addAll(quickFilters);
            });
          },
          onReset: () {
            Navigator.of(modalContext).pop(); // Close the modal
            setState(() {
              selectedWasteType = null;
              selectedDateRange = null;
              multiSelectOptions.clear();
            });
          },
        );
      },
    );
  }

  bool _matchQuickOptions(DateTime timestamp) {
    final now = DateTime.now();

    for (final option in multiSelectOptions) {
      if (option == 'Today' && _isSameDay(timestamp, now)) return true;
      if (option == 'Yesterday' && _isSameDay(timestamp, now.subtract(const Duration(days: 1)))) return true;
      if (option == 'Past 7 days' && timestamp.isAfter(now.subtract(const Duration(days: 7)))) return true;
      if (option == 'Past 30 days' && timestamp.isAfter(now.subtract(const Duration(days: 30)))) return true;
    }

    return false;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) return 'Today';
    if (entryDate == today.subtract(const Duration(days: 1))) return 'Yesterday';

    return DateFormat('MMMM d, y').format(entryDate);
  }

  Map<String, List<LogEntry>> _groupEntriesByDate(List<LogEntry> entries) {
    final Map<String, List<LogEntry>> grouped = {};

    for (final entry in entries) {
      final dateLabel = _formatDate(entry.timestamp);
      grouped.putIfAbsent(dateLabel, () => []).add(entry);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.toLowerCase();

    final filteredEntries = logEntries.where((entry) {
      final matchesSearch = entry.title.toLowerCase().contains(query) ||
          entry.wasteType.toLowerCase().contains(query) ||
          entry.timestamp.toString().contains(query);

      final matchesWasteType = selectedWasteType == null || entry.wasteType == selectedWasteType;

      final matchesDateRange = selectedDateRange == null ||
          (entry.timestamp.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
              entry.timestamp.isBefore(selectedDateRange!.end.add(const Duration(days: 1))));

      final matchesQuickOptions = multiSelectOptions.isEmpty || _matchQuickOptions(entry.timestamp);

      return matchesSearch && matchesWasteType && matchesDateRange && matchesQuickOptions;
    }).toList();

    final groupedByDate = _groupEntriesByDate(filteredEntries);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 73),
            Image.asset(
              'assets/images/titles/log_disposal.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onFilterTap: () => _showFilterModal(context),
            ),
            if (filteredEntries.isEmpty)
              Expanded(
                child: Center( // Center the message both vertically and horizontally
                  child: Text(
                    "No results found.",
                    style: kTitleMedium.copyWith(color: kDarkGrey), // Optional: Add styling
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: groupedByDate.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.key,
                              style: kTitleMedium.copyWith(
                                color: kForestGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Divider(thickness: 2, color: kDarkGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...entry.value.map((log) => LogCard(entry: log)).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
