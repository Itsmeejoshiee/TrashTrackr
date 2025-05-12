import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/disposal_guide.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';

class LogDetailsScreen extends StatelessWidget {
  final LogEntry entry;

  const LogDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Log Details',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Product Title and Waste Type Icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: kTitleLarge.copyWith(
                        color: kAvocado,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    _getWasteTypeImage(entry.wasteType),
                    height: 18,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Product Properties
              PropertiesTile(
                materials: entry.productProperties, // Pass product properties as materials
                classification: entry.wasteType, // Pass waste type as classification
              ),

              const SizedBox(height: 10),

              // Product Info
              Text(
                'Product Info',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                entry.productInfo,
                style: kTitleSmall.copyWith(color: Colors.black54),
              ),

              const SizedBox(height: 10),

              // Recommended Disposal Techniques
              Text(
                'Recommended Disposal Techniques',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DisposalGuide(
                material: entry.wasteType,
                guide: "Here's how to dispose of ${entry.wasteType} responsibly:",
                toDo: entry.disposalGuideToDo,
                notToDo: entry.disposalGuideNotToDo,
                proTip: entry.disposalGuideProTip,
              ),

              const SizedBox(height: 23),

              // Disposal Locations
              Text(
                'Disposal Locations',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                entry.disposalLocation,
                style: kTitleSmall.copyWith(color: Colors.black54),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps a waste type string to the appropriate image asset path.
  String _getWasteTypeImage(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return 'assets/images/icons/recycling.png';
      case 'biodegradable':
        return 'assets/images/icons/leaf_brown.png';
      case 'non-biodegradable':
        return 'assets/images/icons/trashcan.png';
      case 'e-waste':
        return 'assets/images/icons/battery-blue.png';
      default:
        return 'assets/images/icons/plant.png'; // Fallback icon
    }
  }
}

