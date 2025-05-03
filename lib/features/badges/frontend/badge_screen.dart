import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/eco_badge.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double badgeTitleOffset = screenHeight / 20;
    final double imageSize = (screenWidth / 2.5) + 60;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: badgeTitleOffset),
          Image.asset(
            'assets/images/badges/badges_title.png',
            width: imageSize,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  BadgeBox(
                    badge: EcoBadge.greenStreaker,
                  ),
                  BadgeBox(
                    badge: EcoBadge.ecoChampion,
                  ),
                  BadgeBox(
                    badge: EcoBadge.greenStreaker,
                  ),
                  BadgeBox(
                    badge: EcoBadge.dailyDiligent,
                  ),
                  BadgeBox(
                    badge: EcoBadge.weekendWarrior,
                  ),
                  BadgeBox(
                    badge: EcoBadge.scannerRookie,
                  ),
                  BadgeBox(
                    badge: EcoBadge.sortingExpert,
                  ),
                  BadgeBox(
                    badge: EcoBadge.plasticBuster,
                  ),
                  BadgeBox(
                    badge: EcoBadge.barcodeSleuth,
                  ),
                  BadgeBox(
                    badge: EcoBadge.zeroWasteHero,
                  ),
                  BadgeBox(
                    badge: EcoBadge.ecoInfluencer,
                  ),
                  BadgeBox(
                    badge: EcoBadge.cleanupCaptain,
                  ),
                  BadgeBox(
                    badge: EcoBadge.trashTrackrOg,
                  ),
                  BadgeBox(
                    badge: EcoBadge.quizMaster,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
