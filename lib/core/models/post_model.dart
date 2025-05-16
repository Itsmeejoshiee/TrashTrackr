import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/utils/emotion.dart';

class PostModel {
  final String? id;
  final String uid;
  final String fullName;
  final String profilePicture;
  final Timestamp timestamp;
  final Emotion emotion;
  final String body;
  final String imageUrl;

  PostModel({
    this.id,
    required this.uid,
    required this.fullName,
    required this.profilePicture,
    required this.timestamp,
    required this.emotion,
    required this.body,
    required this.imageUrl,
  });

  // Example: fromMap and toMap for Firebase integration
  factory PostModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      PostModel(
        id: id,
        uid: map['uid'] ?? '',
        fullName: map['full_name'] ?? '',
        profilePicture: map['profile_picture'] ?? '',
        timestamp: map['timestamp'],
        emotion: Emotion.fromString(map['emotion']),
        body: map['body'] ?? '',
        imageUrl: map['image_url'] ?? '',
      );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'id': id,
    'full_name': fullName,
    'profile_picture': profilePicture,
    'timestamp': timestamp,
    'emotion': emotion.name,
    'body': body,
    'image_url': imageUrl,
  };

  PostModel copyWith({
    String? id,
    String? uid,
    String? fullName,
    String? profilePicture,
    Timestamp? timestamp,
    Emotion? emotion,
    String? body,
    String? imageUrl,
  }) {
    return PostModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      timestamp: timestamp ?? this.timestamp,
      emotion: emotion ?? this.emotion,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Dummy user info as static fields
  static const String dummyFullname = "Ella Green";
  static const String dummyUserPfp = "assets/images/placeholder_profile.jpg";
  static const String dummyUid = "user123";
}
