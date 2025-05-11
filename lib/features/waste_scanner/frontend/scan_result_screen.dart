// screens/scan_result_screen.dart
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'widgets/properties_tile.dart';
import 'widgets/disposal_guide.dart';
import 'widgets/scan_result_field.dart';
import 'widgets/log_button.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';

class ScanResultScreen extends StatefulWidget {
  final ScanResult scanResult;

  const ScanResultScreen({super.key, required this.scanResult});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final result = widget.scanResult;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Waste Scanner',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Product Title
              Row(
                children: [
                  Text(
                    result.productName,
                    style: kTitleLarge.copyWith(
                      color: kAvocado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    result.classification == 'biodegradable'
                        ? 'assets/images/icons/bio.png'
                        : 'assets/images/icons/nonbio.png',
                    height: 18,
                  ),
                ],
              ),

              PropertiesTile(
                materials: result.materials,
                classification: result.classification,
              ),

              SizedBox(height: 10),

              Text(
                'Recommended Disposal Techniques',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              DisposalGuide(
                material: result.productName,
                toDo: result.toDo,
                notToDo: result.notToDo,
                proTip: result.proTip,
              ),

              SizedBox(height: 23),

              Text(
                'Disposal Locations',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              DisposalLocationButton(onPressed: () {}),

              SizedBox(height: 23),

              Text(
                'Notes (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              ScanResultField(controller: _noteController),

              SizedBox(height: 23),

              Text(
                'Quantity (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              ScanResultField(controller: _quantityController, width: 80),

              SizedBox(height: 40),

              Align(
                alignment: Alignment.centerRight,
                child: LogButton(onPressed: () {}),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
