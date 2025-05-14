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

}