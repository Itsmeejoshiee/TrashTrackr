import 'package:cloud_firestore/cloud_firestore.dart';

class NotifModel {
  final String id;
  final String fullName;
  final String profilePicture;
  final String postId;
  final String likerUid;
  final Timestamp timestamp;
  final bool isRead;
  final bool isForLike;

  NotifModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.postId,
    required this.likerUid,
    required this.timestamp,
    required this.isRead,
    required this.isForLike,
  });

  factory NotifModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NotifModel(
      id: doc.id,
      fullName: data['likerName'] ?? 'Unknown',
      profilePicture: data['likerProfilePic'] ?? '',
      postId: data['postId'] ?? '',
      likerUid: data['likerUid'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      isRead: data['read'] ?? false,
      isForLike: data['type'] == 'like',
    );
  }
}
