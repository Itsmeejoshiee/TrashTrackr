import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class StatBoard extends StatelessWidget {
  const StatBoard({
    super.key,
    required this.wasteDisposals,
    required this.streak,
    required this.badges,
  });

  final int wasteDisposals;
  final int streak;
  final int badges;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: NeoBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/icons/plastic.png', height: 35),
                    SizedBox(width: 12),
                    Text(
                      'Waste',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Center(
                  child: Text(
                    '$wasteDisposals',
                    style: kPoppinsDisplayMedium.copyWith(
                      fontSize: 58,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Center(child: Text('times', style: kTitleLarge)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              NeoBox(
                height: 100,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform.translate(
                        offset: Offset(-10, -10),
                        child: Image.asset(
                          'assets/images/icons/fire.png',
                          height: 50,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(-5, -5),
                        child: Text(
                          '$streak',
                          style: kPoppinsDisplaySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(-3, 0),
                        child: Text('Streak', style: kPoppinsBodyMedium),
                      ),
                    ),
                  ],
                ),
              ),
              NeoBox(
                height: 100,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform.translate(
                        offset: Offset(-10, -10),
                        child: Image.asset(
                          'assets/images/icons/leaf_badge.png',
                          height: 50,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(-5, -5),
                        child: Text(
                          '$badges',
                          style: kPoppinsDisplaySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(-3, 0),
                        child: Text('Badges', style: kPoppinsBodyMedium),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
