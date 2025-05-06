import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/eco_badge.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class BadgeBox extends StatelessWidget {
  const BadgeBox({
    super.key,
    required this.badge,
    this.percent = 0,
    this.isEarned = true,
  });

  final EcoBadge badge;
  final double percent;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/badges/${(isEarned) ? 'colored' : 'gray'}/${badgePath[badge]}';
    return GestureDetector(
      onTap: () {
        Alert(
          context: context,
          style: AlertStyle(
            animationType: AnimationType.grow,
            isCloseButton: false,
            isButtonVisible: false,
            descStyle: kTitleMedium.copyWith(color: Color(0xFF4A4A4A)),
            descPadding: EdgeInsets.symmetric(horizontal: 60),
          ),
          desc: badgeDesc[badge],
          image: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CircularPercentIndicator(
              radius: 100,
              lineWidth: 18,
              backgroundColor: kAppleGreen.withOpacity(0.25),
              progressColor: kAppleGreen,
              circularStrokeCap: CircularStrokeCap.round,
              percent: (isEarned) ? 1 : percent,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 100,
                  ),
                  Text(
                    badgeTitle[badge]!,
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontFamily: 'Urbanist',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).show();
      },
      child: NeoBox(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 65,
            ),
            Text(
              badgeTitle[badge]!,
              style: TextStyle(
                color: Color(0xFF4A4A4A),
                fontFamily: 'Urbanist',
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}