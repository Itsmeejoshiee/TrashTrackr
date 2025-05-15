import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_details.dart';
import '../../../features/log_disposal/models/log_entry.dart';


import '../../utils/constants.dart';

class LogCard extends StatelessWidget {
  final ScanResult result;
  final LogEntry? entry;
  final String fromScreen;

  const LogCard({super.key, required this.result, this.entry, required this.fromScreen,});

  String getIconPath(String classification) {
    if (classification == 'Biodegradable' || classification == 'biodegradable') {
      return 'assets/images/icons/bio.png';
    } else if (classification == 'Recyclable' || classification == 'recyclable') {
      return 'assets/images/icons/recycling.png';
    } else {
      return 'assets/images/icons/nonbio.png';
    }
  }
  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogDetails(
              fromScreen: fromScreen,
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
                    Image.asset(getIconPath(result.classification), width: 16, height: 16),
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
