import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';

class BadgeService {
  final AuthService _authService = AuthService();

  // Initialize all unearned badges
  Future<void> initUserBadges() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot initialize user badges.');
      return;
    }

    final badges = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges');

    for (int i = 1; i < 15; i++) {
      final badgeType = badgeId[i];
      String docRef = badgeTitle[badgeType]!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '');
      final currentBadge = BadgeModel(id: i, percent: 0);
      await badges.doc(docRef).set(currentBadge.toMap());
    }
  }

  // Fetch badge stream
  Stream<List<BadgeModel>> getBadgeStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch activity stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BadgeModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Check scanner rookie badge
  Future<void> checkScannerRookie() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot check Scanner Rookie badge');
      return;
    }

    final badgeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .doc('scanner_rookie');

    try {
      // Fetch the current badge data
      final badgeSnapshot = await badgeRef.get();

      if (badgeSnapshot.exists) {
        final badgeData = badgeSnapshot.data();
        final double currentPercent = badgeData?['percent'] ?? 0;

        // If the percent is already 1, exit early
        if (currentPercent >= 1) {
          print('Scanner Rookie badge already earned. Skipping check.');
          return;
        }
      }

      // Query the activity_log subcollection for documents with activity = 'scan'
      final activityLog =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where('activity', isEqualTo: 'scan')
              .get();

      // Calculate the new percent
      final double percent =
          (activityLog.docs.length >= 10) ? 1 : activityLog.docs.length / 10;
      final bool isEarned = percent >= 1;

      // Update the badge with the new percent and earned status
      await badgeRef.update({'is_earned': isEarned, 'percent': percent});

      print(
        'Scanner Rookie badge updated: percent = $percent, isEarned = $isEarned',
      );
    } catch (e) {
      print('Error checking Scanner Rookie badge: $e');
    }
  }

  Future<void> checkTrashTrackrOg() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot check TrashTrackr OG badge');
      return;
    }

    final badgeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .doc('trashtrackr_og');

    try {
      // Fetch the current badge data
      final badgeSnapshot = await badgeRef.get();

      if (badgeSnapshot.exists) {
        final badgeData = badgeSnapshot.data();
        final double currentPercent = badgeData?['percent'] ?? 0;

        // If the percent is already 1, exit early
        if (currentPercent >= 1) {
          print('Trash Tracker OG badge already earned. Skipping check.');
          return;
        }
      }

      // Define the cutoff date (July 1, 2025)
      final cutoffDate = DateTime(2025, 7, 1);

      // Query the activity_log subcollection for documents before the cutoff date
      final activityLog =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
              .get();

      // Calculate the new percent
      final double percent = activityLog.docs.isNotEmpty ? 1 : 0;
      final bool isEarned = percent >= 1;

      // Update the badge with the new percent and earned status
      await badgeRef.update({'is_earned': isEarned, 'percent': percent});

      print(
        'Trash Tracker OG badge updated: percent = $percent, isEarned = $isEarned',
      );
    } catch (e) {
      print('Error checking Trash Tracker OG badge: $e');
    }
  }

  Future<void> checkGreenStreaker() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot check Green Streaker badge');
      return;
    }

    final badgeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .doc('green_streaker');

    try {
      // Fetch the current badge data
      final badgeSnapshot = await badgeRef.get();

      if (badgeSnapshot.exists) {
        final badgeData = badgeSnapshot.data();
        final double currentPercent = badgeData?['percent'] ?? 0;

        // If the percent is already 1, exit early
        if (currentPercent >= 1) {
          print('Green Streaker badge already earned. Skipping check.');
          return;
        }
      }

      // Query the activity_log subcollection for the last 7 days
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(Duration(days: 7));

      final activityLog =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo),
              )
              .orderBy('timestamp', descending: true)
              .get();

      // Extract the dates of the activities
      final activityDates =
          activityLog.docs
              .map((doc) => (doc['timestamp'] as Timestamp).toDate())
              .toList();

      // Calculate the streak
      int streak = 0;
      DateTime? previousDate;

      for (final date in activityDates) {
        if (previousDate == null || previousDate.difference(date).inDays == 1) {
          streak++;
        } else if (previousDate.difference(date).inDays > 1) {
          break; // Streak is broken
        }
        previousDate = date;
      }

      // Update the badge based on the streak
      final double percent = streak >= 7 ? 1 : streak / 7;
      final bool isEarned = percent >= 1;

      if (streak < 7) {
        print('Streak broken or incomplete. Current streak: $streak days.');
      } else {
        print('7-day streak achieved! Green Streaker badge unlocked!');
      }

      await badgeRef.update({'is_earned': isEarned, 'percent': percent});

      print(
        'Green Streaker badge updated: percent = $percent, isEarned = $isEarned',
      );
    } catch (e) {
      print('Error checking Green Streaker badge: $e');
    }
  }

  Future<void> checkWeekendWarrior() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot check Weekend Warrior badge');
      return;
    }

    final badgeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .doc('weekend_warrior');

    try {
      // Fetch the current badge data
      final badgeSnapshot = await badgeRef.get();

      if (badgeSnapshot.exists) {
        final badgeData = badgeSnapshot.data();
        final double currentPercent = badgeData?['percent'] ?? 0;

        // If the percent is already 1, exit early
        if (currentPercent >= 1) {
          print('Weekend Warrior badge already earned. Skipping check.');
          return;
        }
      }

      // Query the activity_log subcollection for the last 7 days
      final now = DateTime.now();
      final lastSaturday = now.subtract(
        Duration(days: now.weekday % 7 + 1),
      ); // Last Saturday
      final lastSunday = lastSaturday.add(Duration(days: 1)); // Last Sunday

      // Query for Saturday activities
      final saturdayActivities =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(lastSaturday),
              )
              .where(
                'timestamp',
                isLessThan: Timestamp.fromDate(
                  lastSaturday.add(Duration(days: 1)),
                ),
              )
              .get();

      // Query for Sunday activities
      final sundayActivities =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(lastSunday),
              )
              .where(
                'timestamp',
                isLessThan: Timestamp.fromDate(
                  lastSunday.add(Duration(days: 1)),
                ),
              )
              .get();

      // Check if there are activities on both Saturday and Sunday
      final bool hasSaturdayActivity = saturdayActivities.docs.isNotEmpty;
      final bool hasSundayActivity = sundayActivities.docs.isNotEmpty;

      // Update the badge based on the condition
      final double percent = (hasSaturdayActivity && hasSundayActivity) ? 1 : 0;
      final bool isEarned = percent >= 1;

      if (isEarned) {
        print(
          'Weekend Warrior badge unlocked! Activities found on both Saturday and Sunday.',
        );
      } else {
        print(
          'Weekend Warrior badge not earned. Missing activities on either Saturday or Sunday.',
        );
      }

      await badgeRef.update({'is_earned': isEarned, 'percent': percent});

      print(
        'Weekend Warrior badge updated: percent = $percent, isEarned = $isEarned',
      );
    } catch (e) {
      print('Error checking Weekend Warrior badge: $e');
    }
  }

  Future<void> checkDailyDiligent() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot check Daily Diligent badge');
      return;
    }

    final badgeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('badges')
        .doc('daily_diligent');

    try {
      // Fetch the current badge data
      final badgeSnapshot = await badgeRef.get();

      if (badgeSnapshot.exists) {
        final badgeData = badgeSnapshot.data();
        final double currentPercent = badgeData?['percent'] ?? 0;

        // If the percent is already 1, exit early
        if (currentPercent >= 1) {
          print('Daily Diligent badge already earned. Skipping check.');
          return;
        }
      }

      // Query the activity_log subcollection for the last 5 days
      final now = DateTime.now();
      final fiveDaysAgo = now.subtract(Duration(days: 5));

      final activityLog =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('activity_log')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(fiveDaysAgo),
              )
              .orderBy('timestamp', descending: true)
              .get();

      // Extract the dates of the activities
      final activityDates =
          activityLog.docs
              .map((doc) => (doc['timestamp'] as Timestamp).toDate())
              .toList();

      // Calculate the streak
      int streak = 0;
      DateTime? previousDate;

      for (final date in activityDates) {
        if (previousDate == null || previousDate.difference(date).inDays == 1) {
          streak++;
        } else if (previousDate.difference(date).inDays > 1) {
          break; // Streak is broken
        }
        previousDate = date;
      }

      // Update the badge based on the streak
      final double percent = streak >= 5 ? 1 : streak / 5;
      final bool isEarned = percent >= 1;

      if (streak < 5) {
        print('Streak broken or incomplete. Current streak: $streak days.');
      } else {
        print('5-day streak achieved! Daily Diligent badge unlocked!');
      }

      await badgeRef.update({'is_earned': isEarned, 'percent': percent});

      print(
        'Daily Diligent badge updated: percent = $percent, isEarned = $isEarned',
      );
    } catch (e) {
      print('Error checking Daily Diligent badge: $e');
    }
  }
}
