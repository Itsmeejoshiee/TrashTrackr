import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/features/waste_stats/frontend/views/log_history_view.dart';
import 'package:trashtrackr/features/waste_stats/frontend/views/summary_view.dart';

import '../../../core/widgets/buttons/multi_action_fab.dart';
import '../../../core/widgets/list_tiles/view_switch_tile.dart';

class WasteStatsScreen extends StatefulWidget {
  const WasteStatsScreen({super.key});

  @override
  State<WasteStatsScreen> createState() => _WasteStatsScreenState();
}

class _WasteStatsScreenState extends State<WasteStatsScreen> {
  NavRoute _selectedRoute = NavRoute.badge;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  // Switch screen
  bool _updateView = true;
  bool _updateGraph = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double statsTitleOffset = screenHeight / 80;
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
            // Offset
            SizedBox(height: statsTitleOffset),

            // Waste Stats Title
            Center(
              child: Image.asset(
                'assets/images/titles/waste_stats_title.png',
                width: imageSize,
              ),
            ),

            // Offset
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
                : Expanded(child: LogHistoryView()),
          ],
        ),
      ),

      bottomNavigationBar: MainNavigationBar(
        activeRoute: _selectedRoute,
        onSelect: _selectRoute,
      ),

      floatingActionButton: MultiActionFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
