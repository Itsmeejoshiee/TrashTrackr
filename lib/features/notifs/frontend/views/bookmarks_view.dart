import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = (screenWidth / 3) + 60;
    final double bottomOffset = screenHeight / 8;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/components/no_bookmarks.png', width: imageSize),
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
      ),
    );
  }
}