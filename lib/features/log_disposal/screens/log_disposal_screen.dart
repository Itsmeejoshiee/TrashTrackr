import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_card.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/widgets/text_fields/search_bar.dart';

/// Screen that displays a list of log entries related to waste disposal,
/// grouped by the date they were recorded.
class LogDisposalScreen extends StatefulWidget {
  const LogDisposalScreen({super.key});

  @override
  State<LogDisposalScreen> createState() => _LogDisposalScreenState();
}

class _LogDisposalScreenState extends State<LogDisposalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  /// Dummy log entries for display purposes
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
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter entries based on the search query
    final filteredEntries = dummyEntries.where((entry) {
      final query = searchQuery.toLowerCase();
      return entry.title.toLowerCase().contains(query) ||
          entry.wasteType.toLowerCase().contains(query) ||
          entry.status.toLowerCase().contains(query);
    }).toList();

    // Group filtered entries by date
    final Map<String, List<LogEntry>> groupedByDate = {};
    for (var entry in filteredEntries) {
      final key = _formatDate(entry.timestamp);
      groupedByDate.putIfAbsent(key, () => []).add(entry);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 37),
            Image.asset(
              'assets/images/titles/log_disposal.png',
              height: 100,
            ),
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            if (filteredEntries.isEmpty)
              const Expanded(
                child: Center(child: Text("No results found.")),
              )
            else
              Expanded(
                child: ListView(
                  children: groupedByDate.entries.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              e.key,
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
                        const SizedBox(height: 4),
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

  /// Returns a string label for the given date.
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(entryDate);
    }
  }
}
