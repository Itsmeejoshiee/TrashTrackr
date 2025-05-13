import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class BadgeBox extends StatelessWidget {
  const BadgeBox({
    super.key,
    required this.badge,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  final BadgeModel badge;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/badges/${(badge.percent >= 1) ? 'colored' : 'gray'}/${badge.imagePath}';
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
          desc: badge.desc,
          image: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CircularPercentIndicator(
              radius: 100,
              lineWidth: 18,
              backgroundColor: kAppleGreen.withOpacity(0.25),
              progressColor: kAppleGreen,
              circularStrokeCap: CircularStrokeCap.round,
              percent: badge.percent,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 100,
                  ),
                  Text(
                    badge.title,
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
        width: width,
        height: height,
        margin: padding ?? EdgeInsets.all(10),
        padding: margin ?? EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 65,
            ),
            Text(
              badge.title,
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