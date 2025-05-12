import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/date_button.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/log_card.dart';
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
  late Future<List<ScanResult>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = _service.fetchWasteEntries();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanResult>>(
      future: _logsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final logs = snapshot.data ?? [];

        // Group logs by date category
        final Map<String, List<ScanResult>> categorizedLogs = {
          'Today': [],
          'Yesterday': [],
          'Earlier': [],
        };

        for (var log in logs) {
          final category = _formatDateCategory(log.timestamp ?? DateTime.now());
          categorizedLogs[category]?.add(log);
        }

        // main body
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Filter Buttons
              Row(
                children: [
                  DateButton(onPressed: () {}),
                  const SizedBox(width: 8),
                  TypesButton(onPressed: () {}),
                ],
              ),

              SizedBox(height: 20),

              // Section Builder
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
                    LogCard(
                      // TODO: Update image
                      itemImage: Image.asset('assets/images/covers/log_image.png'),
                      name: log.productName,
                      dateTime: log.timestamp ?? DateTime.now(),
                      type: log.classification,
                    ),
                ],
            ],
          ),
        );
      },
    );
  }
}

