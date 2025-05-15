import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trashtrackr/features/feed/web_view/know_your_bin_article.dart';
import 'package:trashtrackr/features/feed/web_view/recycling_code_article.dart';
import 'package:trashtrackr/features/feed/web_view/special_waste_article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecyclingGuideCard extends StatelessWidget {
  const RecyclingGuideCard({super.key, this.index = 1});

  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 141,
        height: 174,
        margin: EdgeInsets.only(right: 17),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/recycling_guide/guide$index.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SpecialWasteArticle()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KnowYourBinArticle()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecyclingCodeArticle()),
          );
        }
      },
    );
  }
}
