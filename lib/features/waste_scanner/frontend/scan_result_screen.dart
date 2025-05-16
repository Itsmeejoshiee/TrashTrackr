import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/waste_scanner_screen.dart';
import 'widgets/properties_tile.dart';
import 'widgets/disposal_guide.dart';
import 'widgets/scan_result_field.dart';
import 'widgets/log_button.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/core/services/waste_entry_service.dart';

class ScanResultScreen extends StatefulWidget {
  final ScanResult scanResult;

  const ScanResultScreen({super.key, required this.scanResult});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  final ActivityService _activityService = ActivityService();
  final BadgeService _badgeService = BadgeService();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.scanResult.notes;
    _quantityController.text = widget.scanResult.qty.toString();
    _activityService.logActivity('scan');
    _badgeService.checkTrashTrackrOg();
    _badgeService.checkScannerRookie();
    _badgeService.checkGreenStreaker();
    _badgeService.checkDailyDiligent();
    _badgeService.checkWeekendWarrior();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String getIconPath(String classification) {
    if (classification == 'Biodegradable' ||
        classification == 'biodegradable') {
      return 'assets/images/icons/bio.png';
    } else if (classification == 'Recyclable' ||
        classification == 'recyclable') {
      return 'assets/images/icons/recycling.png';
    } else {
      return 'assets/images/icons/nonbio.png';
    }
  }

  void _logDisposal() {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Log Successful",
      desc: "Congrats! You've successfully logged your waste. 🌿👏",
      image: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Image.asset("assets/images/icons/logDisposal.png", width: 90),
      ),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kAvocado,
          radius: BorderRadius.circular(30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WasteScannerScreen()),
            );
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Log Another?',
              style: kTitleSmall.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.scanResult;

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
                  Image.asset(getIconPath(result.classification), height: 18),
                ],
              ),

              PropertiesTile(
                materials: result.materials,
                classification: result.classification,
              ),

              SizedBox(height: 10),

              Text(
                'Product Info',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                result.prodInfo,
                style: kPoppinsBodyMedium.copyWith(color: Colors.black54),
              ),

              SizedBox(height: 10),

              Text(
                'Recommended Disposal Techniques',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DisposalGuide(
                material: result.productName,
                guide: result.productName,
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

              DisposalLocationButton(),

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
                child: LogButton(
                  title: 'Log This',
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User not logged in")),
                      );
                      return;
                    }

                    final WasteEntryService service = WasteEntryService();

                    try {
                      final updatedResult = ScanResult(
                        productName: widget.scanResult.productName,
                        materials: widget.scanResult.materials,
                        prodInfo: widget.scanResult.prodInfo,
                        classification: widget.scanResult.classification,
                        toDo: widget.scanResult.toDo,
                        notToDo: widget.scanResult.notToDo,
                        proTip: widget.scanResult.proTip,
                        notes: _noteController.text.trim(),
                        qty: int.tryParse(_quantityController.text.trim()) ?? 0,
                        imageUrl: widget.scanResult.imageUrl,
                        timestamp: DateTime.now(),
                      );

                      await service.addWasteEntry(updatedResult);
                      _logDisposal();
                    } catch (e) {
                      print("Error logging waste entry: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to log waste entry.")),
                      );
                    }
                  },
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
