import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/list_tiles/view_switch_tile.dart';
import '../../../core/models/notif_model.dart';
import '../../../core/services/notif_service.dart';
import 'widgets/notif_card.dart';
import 'views/updates_view.dart';
import 'views/bookmarks_view.dart';

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  bool _updateView = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = (screenWidth / 3) + 60;
    final currentUser = FirebaseAuth.instance.currentUser;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomOffset = screenHeight / 8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
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
            Image.asset(
              'assets/images/titles/notifs_title.png',
              width: imageSize,
            ),
            const SizedBox(height: 8),

            // Switch View Toggle
            ViewSwitchTile(
              value: _updateView,
              firstViewTitle: 'Updates',
              secondViewTitle: 'Bookmarks',
              onFirstView: () => setState(() => _updateView = true),
              onSecondView: () => setState(() => _updateView = false),
            ),

            // Notifications or Bookmarks
            Expanded(
              child:
                  _updateView
                      ? (currentUser == null
                          ? const Center(
                            child: Text('Please log in to see notifications.'),
                          )
                          : StreamBuilder<List<NotifModel>>(
                            stream: NotifService().getNotificationsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: kAvocado,
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Error loading notifications'),
                                );
                              }
                              final notifications = snapshot.data ?? [];
                              if (notifications.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/components/no_notifs.png',
                                      width: imageSize,
                                    ),
                                    Text(
                                      "You're all caught up!",
                                      style: kDisplaySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text('Nothing new right now.'),
                                    SizedBox(height: 15),
                                    Text(
                                      'Check back later for new challenges,\nbadges, and community updates. 🌱',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: bottomOffset),
                                  ],
                                );
                              }
                              return UpdatesView(
                                context: context,
                                children:
                                    notifications.map((notif) {
                                      return NotifCard(
                                        username: notif.fullName,
                                        profilePicture: notif.profilePicture,
                                        timestamp: notif.timestamp.toDate(),
                                        notifType:
                                            notif.isForLike
                                                ? 'like'
                                                : 'comment',
                                      );
                                    }).toList(),
                              );
                            },
                          ))
                      : const BookmarksView(),
            ),
          ],
        ),
      ),
    );
  }
}
