import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';
import 'package:trashtrackr/features/waste_stats/frontend/views/log_history_view.dart';
import 'package:trashtrackr/features/waste_stats/frontend/views/summary_view.dart';
import '../../../core/widgets/list_tiles/view_switch_tile.dart';

class WasteStatsScreen extends StatefulWidget {
  const WasteStatsScreen({super.key, required this.updateView});

  final bool updateView;

  @override
  State<WasteStatsScreen> createState() => _WasteStatsScreenState();
}

class _WasteStatsScreenState extends State<WasteStatsScreen> {
  late bool _updateView;
  bool _updateGraph = true;

  @override
  void initState() {
    super.initState();
    _updateView = widget.updateView;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = (screenWidth / 2) + 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Dashboard',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            // Waste Stats Title
            Center(
              child: Image.asset(
                'assets/images/titles/waste_stats_title.png',
                width: imageSize,
              ),
            ),

            SizedBox(height: 4),

            // Waste Stats Switch Tile
            ViewSwitchTile(
              value: _updateView,
              firstViewTitle: 'Summary',
              secondViewTitle: 'Log History',
              onFirstView: () {
                setState(() => _updateView = true);
              },
              onSecondView: () {
                setState(() => _updateView = false);
              },
            ),

            // Waste Stats Content
            (_updateView)
                ? Expanded(
              child: SummaryView(
                updateView: _updateGraph,
                firstViewTitle: "Weekly",
                secondViewTitle: "Monthly",
                onFirstView: () => setState(() => _updateGraph = true),
                onSecondView: () => setState(() => _updateGraph = false),
              ),
            )
                : const Expanded(child: LogHistoryView()),
          ],
        ),
      ),
    );
  }
}
