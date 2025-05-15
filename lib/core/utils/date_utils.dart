import 'package:trashtrackr/core/models/activity_model.dart';

class DateUtilsHelper {
  int getNumberOfDaysInCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  String getMonthName(int month) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }

  int getCurrentStreakFromActivities(List<ActivityModel> activities) {
    final Set<DateTime> uniqueDays = {
      for (var activity in activities)
        DateTime(
          activity.timestamp.toDate().year,
          activity.timestamp.toDate().month,
          activity.timestamp.toDate().day,
        ),
    };

    int streak = 0;
    DateTime current = DateTime.now();

    while (uniqueDays.contains(
      DateTime(current.year, current.month, current.day),
    )) {
      streak++;
      current = current.subtract(Duration(days: 1));
    }

    return streak;
  }
}
