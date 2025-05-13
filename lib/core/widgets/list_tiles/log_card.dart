import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_details.dart';
import '../../../features/log_disposal/models/log_entry.dart';
import '../../../features/log_disposal/screens/log_details_screen.dart';
import '../../../features/log_disposal/screens/log_details_screen.dart';
import '../../utils/constants.dart';

class LogCard extends StatelessWidget {
  final ScanResult result;
  final LogEntry? entry;

  const LogCard({super.key, required this.result, this.entry});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> typeIconMap = {
      'Recycle': 'assets/images/icons/recycling.png',
      'Biodegradable': 'assets/images/icons/leaf_brown.png',
      'Non-biodegradable': 'assets/images/icons/trashcan.png',
    };

    final String? iconPath = typeIconMap[result.classification];
    final Widget icon = iconPath != null
        ? Image.asset(iconPath, width: 16, height: 16)
        : const SizedBox.shrink();

    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogDetails(
              scanResult: result,
              onImageUpdated: (newImageURL) {
                newImageURL = result.imageUrl ?? "";
              },
              onDetailsUpdated: (String notes, String quantity) {},
            ),
          ),
        );
      },



      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        width: screenWidth,
        height: 75,

        child: Row(
          children: [
            result.imageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                result.imageUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox.shrink(),

            SizedBox(width: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.productName,
                  style: kTitleSmall.copyWith(color: kAvocado, fontWeight: FontWeight.w700),
                ),

                Text(
                  result.timestamp != null
                      ? '${DateFormat.yMMMd().format(result.timestamp!)} • ${DateFormat.jm().format(result.timestamp!)}'
                      : 'No timestamp available', // Or any fallback message you prefer
                  style: kLabelMedium.copyWith(
                    color: kGray.withOpacity(0.3),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Row(
                  children: [
                    icon,
                    const SizedBox(width: 6),
                    Text(
                      result.classification,
                      style: kLabelMedium.copyWith(color: kGray.withOpacity(0.3), fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
