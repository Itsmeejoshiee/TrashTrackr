import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/activity_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';

class ActivityService {
  final AuthService _authService = AuthService();

  Future<void> logActivity(String activity) async {
    final uid = _authService.currentUser?.uid;
    final activityModel = ActivityModel(
      activity: activity,
      timestamp: Timestamp.now(),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_log')
        .add(activityModel.toMap());
  }

  Stream<List<ActivityModel>> getActivityStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch activity stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_log')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ActivityModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Fetch all activities for the current user
  Future<dynamic> getAllActivities(bool count) async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch activities');
      return count ? 0 : [];
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('activity_log')
            .orderBy('timestamp', descending: true)
            .get();

    final activities =
        snapshot.docs.map((doc) => ActivityModel.fromMap(doc.data())).toList();

    if (count) {
      return activities.length; // Return the count of activities
    }

    return activities; // Return the list of activities
  }

  Future<int> getEarnedBadges() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch badges');
      return 0;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('badges')
            .where('is_earned', isEqualTo: true) // Firestore-level filter
            .get();

    final earnedBadges = snapshot.docs.map((doc) => doc.data()).toList();

    if (true) {
      return earnedBadges.length;
    }
  }

  Future<int> getScanCount() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch badges');
      return 0;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('activity_log')
            .where('is_earned', isEqualTo: true)
            .where('activity', isEqualTo: 'scan')
            .get();

    return snapshot.docs.length;
  }
}
