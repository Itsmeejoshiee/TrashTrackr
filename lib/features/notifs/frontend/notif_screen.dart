import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/list_tiles/view_switch_tile.dart';
import 'widgets/notif_card.dart';
import 'views/updates_view.dart';
import 'views/bookmarks_view.dart';

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  // Temporary Switch
  bool _updateView = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
            Image.asset('assets/images/titles/notifs_title.png', width: imageSize),

            // Offset
            SizedBox(height: 8),

            // Notif Switch Tile
            ViewSwitchTile(
              value: _updateView,
              firstViewTitle: 'Updates',
              secondViewTitle: 'Bookmarks',
              onFirstView: () {
                setState(() => _updateView = true);
              },
              onSecondView: () {
                setState(() => _updateView = false);
              },
            ),

            (_updateView)
                ? UpdatesView(
                  context: context,
                  children: [
                    NotifCard(),
                    NotifCard(),
                    NotifCard(),
                    NotifCard(),
                  ],
                )
                : BookmarksView(context: context),
          ],
        ),
      ),
    );
  }
}