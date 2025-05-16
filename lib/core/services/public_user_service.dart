import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/activity_model.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/core/models/event_model.dart';

class PublicUserService {
  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Stream<UserModel?> getUserStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.exists ? UserModel.fromMap(snapshot.data()!) : null);
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: uid)
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data(), id: doc.id))
        .toList());
  }

  Stream<List<EventModel>> getUserEvents(String uid) {
    return FirebaseFirestore.instance
        .collection('events')
        .where('uid', isEqualTo: uid)
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data(), id: doc.id))
        .toList());
  }

  Stream<List<ActivityModel>> getActivityStream(String uid) {
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

  Stream<List<BadgeModel>> getBadgeStream(String uid) {
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

  Future<void> incrementFollowerCount(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'follower_count': FieldValue.increment(1),
    });
  }

  Future<Map<String, int>> countDisposalClassifications(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('log_disposal')
        .get();

    final Map<String, int> counts = {
      'Recyclable': 0,
      'Biodegradable': 0,
      'Non-biodegradable': 0,
    };

    for (final doc in snapshot.docs) {
      final classification = doc['classification'] as String?;
      if (classification != null && counts.containsKey(classification)) {
        counts[classification] = counts[classification]! + 1;
      }
    }
    return counts;
  }

}