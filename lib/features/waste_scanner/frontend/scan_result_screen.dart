import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'widgets/properties_tile.dart';
import 'widgets/disposal_guide.dart';
import 'widgets/scan_result_field.dart';
import 'widgets/log_button.dart';

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({super.key});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
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
                spacing: 18,
                children: [
                  Text(
                    'Purple Soda Can',
                    style: kTitleLarge.copyWith(
                      color: kAvocado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset('assets/images/icons/bio.png', height: 18),
                ],
              ),

              // Product Properties
              PropertiesTile(
                material: 'Metal Can',
                savedEmissions: '10g',
              ),

              SizedBox(height: 10),

              // Product Info
              Text(
                'Product Info',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Lorem ipsum dolor sit amet consectetur. Sodales purus diam dolor dolor. Sit a nisl viverra vitae facilisis mauris.',
                style: kTitleSmall.copyWith(color: Colors.black54),
              ),

              SizedBox(height: 10),

              Text(
                'Recommended Disposal Techniques',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              DisposalGuide(
                material: 'Glass Bottles',
                guide: "Glass bottles are 100% recyclable — but only if disposed of properly. Here's how to do it right:",
                toDo: [
                  'Rinse the bottle',
                  'Rome caps or corks',
                  'Sort by color if needed',
                  'Use recycling bins or bottle banks',
                  'Reuse for crafts or storage',
                ],
                notToDo: [
                  "Don't recycle broken glass",
                  'No ceramics, mirrors, or bulbs',
                ],
                proTip: 'Glass is endlessly recyclable without loss in quality. So every time you recycle a bottle, you help reduce raw material use and energy!',
              ),

              SizedBox(height: 23),

              Text(
                'Disposal Locations',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              DisposalLocationButton(
                onPressed: () {},
              ),

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

              ScanResultField(controller: _quantityController, width: 80,),

              SizedBox(height: 40),

              Align(
                alignment: Alignment.centerRight,
                child: LogButton(
                  onPressed: () {},
                ),
              ),

              SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }
}

