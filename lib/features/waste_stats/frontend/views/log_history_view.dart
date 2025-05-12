import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/date_button.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/log_card.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/types_button.dart';

class LogHistoryView extends StatelessWidget {
  LogHistoryView({super.key});

  // Mock data - replace with dynamic list from your source
  final List<Map<String, dynamic>> logData = [
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 12, 0, 01),
      'type': 'Non-Biodegradable'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 11, 0, 01),
      'type': 'Recycle'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 6, 0, 01),
      'type': 'Biodegradable'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 5, 0, 01),
      'type': 'Recycle'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 5, 0, 01),
      'type': 'Biodegradable'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 2, 0, 01),
      'type': 'Recycle'
    },
    {
      'image': 'assets/images/covers/log_image.png',
      'name': 'Coca-cola Glass 100 ml',
      'dateTime': DateTime(2025, 5, 1, 0, 01),
      'type': 'Biodegradable'
    },
  ];

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

    // Group logs by category
    final Map<String, List<Map<String, dynamic>>> categorizedLogs = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    for (var log in logData) {
      final category = _formatDateCategory(log['dateTime']);
      categorizedLogs[category]?.add(log);
    }

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

          // Section Builder
          for (final category in ['Today', 'Yesterday', 'Earlier'])
            if (categorizedLogs[category]!.isNotEmpty) ...[
              // Section Header
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

              // LogCards
              for (final log in categorizedLogs[category]!)
                LogCard(
                  itemImage: Image.asset(log['image']),
                  name: log['name'],
                  dateTime: log['dateTime'],
                  type: log['type'],
                ),
            ],
        ],
      ),
    );
  }
}
