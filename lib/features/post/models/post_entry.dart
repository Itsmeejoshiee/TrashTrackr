import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostEntry {
  final String body;
  final DateTime date;
  final String fullname;
  final String imageUrl;
  final String postId;
  final String uid;
  final String userPfp;

  PostEntry({
    required this.body,
    required this.date,
    required this.fullname,
    required this.imageUrl,
    required this.postId,
    required this.uid,
    required this.userPfp,
  });

  // Example: fromMap and toMap for Firebase integration
  factory PostEntry.fromMap(Map<String, dynamic> map) => PostEntry(
    body: map['body'] ?? '',
    date: (map['date'] as Timestamp).toDate(),
    fullname: map['fullname'] ?? '',
    imageUrl: map['image_url'] ?? '',
    postId: map['post_id'] ?? '',
    uid: map['uid'] ?? '',
    userPfp: map['user_pfp'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'body': body,
    'date': date,
    'fullname': fullname,
    'image_url': imageUrl,
    'post_id': postId,
    'uid': uid,
    'user_pfp': userPfp,
  };

  // Dummy user info as static fields
  static const String dummyFullname = "Ella Green";
  static const String dummyUserPfp = "assets/images/placeholder_profile.jpg";
  static const String dummyUid = "user123";
}

class EventEntry {
  final String imageUrl;
  final String eventType;
  final DateTimeRange dateRange;
  final String eventDescription;

  EventEntry({
    required this.imageUrl,
    required this.eventType,
    required this.dateRange,
    required this.eventDescription,
  });

  // Example: fromMap and toMap for Firebase integration
  factory EventEntry.fromMap(Map<String, dynamic> map) => EventEntry(
    imageUrl: map['image_url'] ?? '',
    eventType: map['event_type'] ?? '',
    dateRange: DateTimeRange(
      start: (map['date_start'] as Timestamp).toDate(),
      end: (map['date_end'] as Timestamp).toDate(),
    ),
    eventDescription: map['event_description'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'image_url': imageUrl,
    'event_type': eventType,
    'date_start': dateRange.start,
    'date_end': dateRange.end,
    'event_description': eventDescription,
  };

  // Dummy event image (optional)
  static const String dummyEventImage = "assets/images/placeholder_event.jpg";
}
