import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/disposal_guide.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/scan_result_field.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/log_button.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';

class LogDetailsScreen extends StatelessWidget {
  final LogEntry entry;

  const LogDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
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

              // Product Title
              Row(
                children: [
                  Text(
                    entry.title,
                    style: kTitleLarge.copyWith(
                      color: kAvocado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing between the title and the icon
                  Image.asset(
                    _getWasteTypeImage(entry.wasteType), // Dynamically fetch icon based on wasteType
                    height: 18,
                  ),
                ],
              ),

              // Product Properties
              PropertiesTile(
                material: entry.wasteType,
                savedEmissions: entry.savedCO2, // Use actual data from the entry
              ),

              const SizedBox(height: 10),

              // Product Info
              Text(
                'Product Info',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                entry.productInfo, // Fetch product info dynamically
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
                toDo: entry.disposalGuideToDo, // Fetch to-do list dynamically
                notToDo: entry.disposalGuideNotToDo, // Fetch not-to-do list dynamically
                proTip: entry.disposalGuideProTip, // Fetch pro tip dynamically
              ),

              const SizedBox(height: 23),

              // Disposal Locations
              Text(
                'Disposal Locations',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                entry.disposalLocation, // Fetch disposal location dynamically
                style: kTitleSmall.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              DisposalLocationButton(
                onPressed: () {},
              ),

              const SizedBox(height: 23),

              // Notes (optional)
              Text(
                'Notes (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ScanResultField(controller: _noteController),

              const SizedBox(height: 23),

              // Quantity (optional)
              Text(
                'Quantity (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ScanResultField(controller: _quantityController, width: 80),

              const SizedBox(height: 40),

              // Log Button
              Align(
                alignment: Alignment.centerRight,
                child: LogButton(
                  onPressed: () {
                    // Handle log action
                  },
                ),
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

