import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/models/notif_model.dart';

import 'auth_service.dart';

class NotifService {
  final AuthService _authService = AuthService();

  // FOR POST
  Future<void> addLikeNotificationToPostOwner({
    required String postId,
    required String likerUid,
  }) async {
    final likerDoc = await FirebaseFirestore.instance.collection('users').doc(likerUid).get();
    if (!likerDoc.exists) return;

    final likerName = (likerDoc.data()?['first_name'] ?? '') + ' ' + (likerDoc.data()?['last_name'] ?? '');
    final likerProfilePic = likerDoc.data()?['profile_picture'] ?? '';

    final postDoc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
    if (!postDoc.exists) return;

    final postOwnerUid = postDoc.data()?['uid'];
    if (postOwnerUid == null || postOwnerUid == likerUid) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(postOwnerUid)
        .collection('notifications')
        .add({
      'type': 'like',
      'postId': postId,
      'likerUid': likerUid,
      'likerName': likerName,
      'likerProfilePic': likerProfilePic,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  }


  // FOR EVENT
  Future<void> addLikeNotificationToEventOwner({
    required String eventId,
    required String likerUid,
  }) async {
    final likerDoc = await FirebaseFirestore.instance.collection('users').doc(likerUid).get();
    if (!likerDoc.exists) return;

    final likerName = (likerDoc.data()?['first_name'] ?? '') + ' ' + (likerDoc.data()?['last_name'] ?? '');
    final likerProfilePic = likerDoc.data()?['profile_picture'] ?? '';

    final eventDoc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();
    if (!eventDoc.exists) return;

    final eventOwnerUid = eventDoc.data()?['uid'];
    if (eventOwnerUid == null || eventOwnerUid == likerUid) return; // avoid self-notification

    await FirebaseFirestore.instance
        .collection('users')
        .doc(eventOwnerUid)
        .collection('notifications')
        .add({
      'type': 'like',
      'eventId': eventId,
      'likerUid': likerUid,
      'likerName': likerName,
      'likerProfilePic': likerProfilePic,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  }


  Stream<List<NotifModel>> getNotificationsStream() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotifModel.fromFirestore(doc);
      }).toList();
    });
  }

}
