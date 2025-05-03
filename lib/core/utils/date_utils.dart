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
}
