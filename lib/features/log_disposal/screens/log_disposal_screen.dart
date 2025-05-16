import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/core/widgets/list_tiles/log_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/search_bar/search_bar.dart';
import 'package:trashtrackr/core/widgets/text_fields/search_bar/filter_modal.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/services/waste_entry_service.dart';

import '../../dashboard/frontend/dashboard_screen.dart';

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

  final WasteEntryService _wasteEntryService = WasteEntryService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() {
        searchQuery = _searchController.text;
      }),
    );
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
          onApply: (
            String? wasteType,
            DateTimeRange? dateRange,
            List<String> quickFilters,
          ) {
            Navigator.of(modalContext).pop();
            setState(() {
              selectedWasteType = wasteType;
              selectedDateRange = dateRange;
              multiSelectOptions
                ..clear()
                ..addAll(quickFilters);
            });
          },
          onReset: () {
            Navigator.of(modalContext).pop();
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

  bool _matchQuickOptions(DateTime? timestamp) {
    if (timestamp == null) return false;
    final now = DateTime.now();

    for (final option in multiSelectOptions) {
      if (option == 'Today' && _isSameDay(timestamp, now)) return true;
      if (option == 'Yesterday' &&
          _isSameDay(timestamp, now.subtract(const Duration(days: 1))))
        return true;
      if (option == 'Past 7 days' &&
          timestamp.isAfter(now.subtract(const Duration(days: 7))))
        return true;
      if (option == 'Past 30 days' &&
          timestamp.isAfter(now.subtract(const Duration(days: 30))))
        return true;
    }

    return false;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) return 'Today';
    if (entryDate == today.subtract(const Duration(days: 1)))
      return 'Yesterday';

    return DateFormat('MMMM d, y').format(entryDate);
  }

  Map<String, List<ScanResult>> _groupEntriesByDate(List<ScanResult> entries) {
    final Map<String, List<ScanResult>> grouped = {};

    for (final entry in entries) {
      final dateLabel = _formatDate(entry.timestamp);
      grouped.putIfAbsent(dateLabel, () => []).add(entry);
    }

    return grouped;
  }

  Stream<List<ScanResult>> fetchWasteEntries() {
    return _wasteEntryService.fetchWasteEntries();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              ),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Dashboard',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Image.asset('assets/images/titles/log_disposal.png', height: 100),
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
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: fetchWasteEntries(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kAvocado),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No results found.",
                        style: kTitleMedium.copyWith(color: kDarkGrey),
                      ),
                    );
                  } else {
                    final wasteEntries = snapshot.data!;

                    final filteredEntries =
                        wasteEntries.where((entry) {
                          final matchesSearch =
                              entry.productName.toLowerCase().contains(query) ||
                              entry.classification.toLowerCase().contains(
                                query,
                              ) ||
                              (entry.timestamp?.toString().contains(query) ??
                                  false);

                          final matchesWasteType =
                              selectedWasteType == null ||
                              entry.classification == selectedWasteType;

                          final matchesDateRange =
                              selectedDateRange == null ||
                              (entry.timestamp != null &&
                                  entry.timestamp!.isAfter(
                                    selectedDateRange!.start.subtract(
                                      const Duration(days: 1),
                                    ),
                                  ) &&
                                  entry.timestamp!.isBefore(
                                    selectedDateRange!.end.add(
                                      const Duration(days: 1),
                                    ),
                                  ));

                          final matchesQuickOptions =
                              multiSelectOptions.isEmpty ||
                              _matchQuickOptions(entry.timestamp);

                          return matchesSearch &&
                              matchesWasteType &&
                              matchesDateRange &&
                              matchesQuickOptions;
                        }).toList();

                    final groupedByDate = _groupEntriesByDate(filteredEntries);

                    return ListView(
                      children:
                          groupedByDate.entries.map((entry) {
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
                                      child: Divider(
                                        thickness: 2,
                                        color: kDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...entry.value
                                    .map(
                                      (log) => LogCard(
                                        result: log,
                                        fromScreen: 'disposal',
                                      ),
                                    )
                                    .toList(),
                                const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
