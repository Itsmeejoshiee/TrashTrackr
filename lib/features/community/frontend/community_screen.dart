import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/list_tiles/view_switch_tile.dart';
import 'package:trashtrackr/features/community/frontend/widgets/past_event_view.dart';
import 'package:trashtrackr/features/community/frontend/widgets/upcoming_event_view.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();

}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _upcomingView = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final double imageSize = (screenWidth / 3) + 60;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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

            // Notif Title
            Image.asset(
                'assets/images/titles/community_title.png', width: imageSize),

            // Offset
            SizedBox(height: 8),

            // Notif Switch Tile
            ViewSwitchTile(
              value: _upcomingView,
              firstViewTitle: 'Upcoming',
              secondViewTitle: 'History',
              onFirstView: () {
                setState(() => _upcomingView = true);
              },
              onSecondView: () {
                setState(() => _upcomingView = false);
              },
            ),

            (_upcomingView)
                ? UpcomingEventView()
                : PastEventView(),

            // Offset
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
