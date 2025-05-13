import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class StreakCalendar extends StatefulWidget {
  const StreakCalendar({super.key});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Eco Streak',
              style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        NeoBox(
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  DateUtilsHelper().getMonthName(),
                  style: kTitleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: DateUtilsHelper().getNumberOfDaysInCurrentMonth(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 22,
                    height: 22,
                    foregroundDecoration: BoxDecoration(
                      color: kGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
