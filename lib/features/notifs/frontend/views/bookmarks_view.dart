import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  Future<List<Map<String, dynamic>>> _fetchBookmarks() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final bookmarksSnap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('bookmarks')
            .orderBy('timestamp', descending: true)
            .get();

    return bookmarksSnap.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Widget>> _fetchBookmarkedCards(
    List<Map<String, dynamic>> bookmarks,
  ) async {
    List<Widget> cards = [];

    for (final bookmark in bookmarks) {
      if (bookmark['type'] == 'post') {
        final postDoc =
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(bookmark['postId'])
                .get();
        if (postDoc.exists) {
          final post = PostModel.fromMap(postDoc.data()!, id: postDoc.id);
          cards.add(PostCard(post: post));
        }
      } else if (bookmark['type'] == 'event') {
        final eventDoc =
            await FirebaseFirestore.instance
                .collection('events')
                .doc(bookmark['eventId'])
                .get();
        if (eventDoc.exists) {
          final event = EventModel.fromMap(eventDoc.data()!, id: eventDoc.id);
          cards.add(EventCard(event: event));
        }
      }
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    print('BOOKMARK VIEW');
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = (screenWidth / 3) + 60;
    final double bottomOffset = screenHeight / 8;
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAvocado),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Bookmark data is not available.'));
          }

          if (snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/components/no_bookmarks.png',
                  width: imageSize,
                ),
                Text(
                  "No bookmarks yet!",
                  style: kDisplaySmall.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text('Looks like you haven’t saved anything yet.'),
                SizedBox(height: 15),
                Text(
                  'Bookmark EcoFeeds you love to easily\nfind them later! 🌱',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: bottomOffset),
              ],
            );
          }

          return FutureBuilder<List<Widget>>(
            future: _fetchBookmarkedCards(snapshot.data!),
            builder: (context, cardSnapshot) {
              if (cardSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kAvocado),
                );
              }
              if (!cardSnapshot.hasData || cardSnapshot.data!.isEmpty) {
                return const Center(child: Text('No bookmarks yet.'));
              }
              return ListView(children: cardSnapshot.data!);
            },
          );
        },
      ),
    );
  }
}
