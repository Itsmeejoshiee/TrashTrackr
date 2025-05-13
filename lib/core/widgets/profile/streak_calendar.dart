import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/activity_model.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class StreakCalendar extends StatefulWidget {
  const StreakCalendar({super.key});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  final DateUtilsHelper _dateUtilsHelper = DateUtilsHelper();
  final UserService _userService = UserService();

  List<int> _buildDayList(List<ActivityModel>? activities) {
    List<int> dayList = [];
    for (ActivityModel activityModel in activities!) {
      final date = activityModel.timestamp.toDate();
      final present = Timestamp.now().toDate();
      if (date.month == present.month && date.year == present.year) {
        final day = date.day;
        dayList.add(day);
      }
    }
    return dayList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.getActivityStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final dayList = _buildDayList(snapshot.data);
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
                        _dateUtilsHelper.getMonthName(),
                        style: kTitleMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _dateUtilsHelper.getNumberOfDaysInCurrentMonth(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        final currentDay = index + 1;
                        final isActive = dayList.contains(currentDay);
                        return StreakCell(isActive: isActive);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }

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
                      _dateUtilsHelper.getMonthName(),
                      style: kTitleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _dateUtilsHelper.getNumberOfDaysInCurrentMonth(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      return StreakCell();
                    },
                  ),
                ],
              ),
            ),
          ],
        );

      },
    );
  }
}

class StreakCell extends StatelessWidget {
  const StreakCell({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      foregroundDecoration: BoxDecoration(
        color: (isActive) ? kAvocado : kGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
