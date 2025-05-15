import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/date_button.dart';
import 'package:trashtrackr/core/widgets/list_tiles/log_card.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/types_button.dart';
import '../../../../core/models/scan_result_model.dart';
import '../../../../core/services/waste_entry_service.dart';

class LogHistoryView extends StatefulWidget {
  const LogHistoryView({super.key});

  @override
  State<LogHistoryView> createState() => _LogHistoryViewState();
}

class _LogHistoryViewState extends State<LogHistoryView> {
  final _service = WasteEntryService();
  bool _isDateSortActive = false;
  bool _isDateAscending = false;
  String _selectedType = "Type";

  @override
  void initState() {
    super.initState();
  }

  void _toggleDateSortOrder() {
    setState(() {
      if (!_isDateSortActive) {
        _isDateSortActive = true;
        _isDateAscending = true;
      } else {
        _isDateAscending = !_isDateAscending;
      }
    });
  }

  String _formatDateCategory(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return 'Earlier';
    }
  }

  Stream<List<ScanResult>> fetchWasteEntries() {
    return _service.fetchWasteEntries();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: fetchWasteEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final logs = snapshot.data ?? [];

        // filter logs based on selected type
        final filteredLogs = _selectedType == "Type"
            ? logs
            : logs.where((log) => log.classification == _selectedType).toList();

        // Group filtered logs by date category
        final Map<String, List<ScanResult>> categorizedLogs = {
          'Today': [],
          'Yesterday': [],
          'Earlier': [],
        };

        for (var log in filteredLogs) {
          final category = _formatDateCategory(log.timestamp ?? DateTime.now());
          categorizedLogs[category]?.add(log);
        }

        // sort each category by date, using _isDateAscending
        for (var category in categorizedLogs.keys) {
          categorizedLogs[category]!.sort((a, b) {
            final timeA = a.timestamp ?? DateTime.now();
            final timeB = b.timestamp ?? DateTime.now();

            return _isDateAscending ? timeA.compareTo(timeB) : timeB.compareTo(timeA);
          });
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DateButton(
                    onPressed: _toggleDateSortOrder,
                    isActive: _isDateSortActive,
                    isAscending: _isDateAscending,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TypesButton(
                      selectedType: _selectedType,
                      onTypeSelected: (String type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              for (final category in ['Today', 'Yesterday', 'Earlier'])
                if (categorizedLogs[category]!.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        category,
                        style: kTitleMedium.copyWith(
                          color: kAvocado,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Flexible(
                        child: Divider(
                          indent: 20,
                          thickness: 2,
                          color: Color(0xff868686),
                        ),
                      ),
                    ],
                  ),
                  for (final log in categorizedLogs[category]!)
                    LogCard(result: log, fromScreen: 'history')
                ],
            ],
          ),
        );
      },
    );
  }
}
