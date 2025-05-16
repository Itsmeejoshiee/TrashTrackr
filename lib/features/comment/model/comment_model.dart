import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String uid;
  final String fullName;
  final String profilePicture;
  final String content;
  final Timestamp timestamp;
  final bool isForEvent;

  CommentModel({
    required this.id,
    required this.postId,
    required this.uid,
    required this.fullName,
    required this.profilePicture,
    required this.content,
    required this.timestamp,
    required this.isForEvent,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'content': content,
      'timestamp': timestamp,
      'isForEvent': isForEvent,
    };
  }

  // Added optional id parameter because ID is in doc.id usually, not in data
  factory CommentModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CommentModel(
      id: id ?? '',
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp']
          : Timestamp.now(),
      isForEvent: map['isForEvent'] ?? false,
    );
  }
}
