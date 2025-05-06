import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import '../models/log_entry.dart';
import '../widgets/log_card.dart';
import 'package:intl/intl.dart';

/// Screen that displays a list of log entries related to waste disposal,
/// grouped by the date they were recorded.
class LogDisposalScreen extends StatelessWidget {
  LogDisposalScreen({super.key});

  /// Dummy log entries for display purposes (can be replaced with data from a database).
  final List<LogEntry> dummyEntries = [
    LogEntry(
      imageUrl: 'assets/images/placeholder-item.png',
      title: 'Coca-cola Glass 100 ml',
      timestamp: DateTime.now(),
      wasteType: 'E-Waste',
      status: 'Scanned',
    ),
    LogEntry(
      imageUrl: 'assets/images/placeholder-item.png',
      title: 'Pepsi Bottle 1L',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      wasteType: 'Recycle',
      status: 'Sorted',
    ),
    LogEntry(
      imageUrl: 'assets/images/placeholder-item.png',
      title: 'Sprite Can 250ml',
      timestamp: DateTime.now(),
      wasteType: 'Non-biodegradable',
      status: 'Scanned',
    ),
    LogEntry(
      imageUrl: 'assets/images/placeholder-item.png',
      title: 'Old Newspaper Bundle',
      timestamp: DateTime(2024, 4, 1),
      wasteType: 'Biodegradable',
      status: 'Disposed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Group entries into a map where keys are formatted dates and values are lists of LogEntry
    Map<String, List<LogEntry>> groupedByDate = {};
    for (var entry in dummyEntries) {
      final key = _formatDate(entry.timestamp);
      groupedByDate.putIfAbsent(key, () => []).add(entry);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Sets a light gray background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32), // Horizontal margin
        child: Column(
          children: [
            const SizedBox(height: 37), // Top spacing
            Image.asset(
              'assets/images/titles/log_disposal.png',
              height: 100, // Logo or title banner image
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search logs...', // Search bar for user input
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between search and list
            Expanded(
              // Scrollable list of grouped logs
              child: ListView(
                children: groupedByDate.entries.map((e) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row for each date group
                      Row(
                        children: [
                          Text(
                            e.key, // e.g., "Today", "Yesterday", or a full date
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

                      // Display LogCards for each log under that date
                      ...e.value.map((log) => LogCard(entry: log)),
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

  /// Returns a string label for the given date:
  /// - "Today" if it's today's date,
  /// - "Yesterday" if it's one day before today,
  /// - Otherwise, formatted as "Month Day, Year"
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(entryDate); // e.g., April 1, 2025
    }
  }
}
