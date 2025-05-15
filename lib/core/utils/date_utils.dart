import 'package:trashtrackr/core/models/activity_model.dart';

class DateUtilsHelper {
  int getNumberOfDaysInCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  String getMonthName() {
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
    final currentDate = DateTime.now();
    return monthNames[currentDate.month - 1];
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

  Future<String> getGreetingMessage() async {
    final now = DateTime.now();
    if (now.hour < 12) {
      return 'Good Morning';
    } else if (now.hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
