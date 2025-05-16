import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/utils/event_type.dart';

class EventModel {
  String? id;
  final String uid;
  final String fullName;
  final String profilePicture;
  final Timestamp timestamp;
  final String imageUrl;
  final String title;
  final EventType type;
  final String address;
  final DateTimeRange dateRange;
  final String startTime;
  final String endTime;
  final String desc;

  EventModel({
    required this.id,
    required this.uid,
    required this.fullName,
    required this.profilePicture,
    required this.timestamp,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.address,
    required this.dateRange,
    required this.startTime,
    required this.endTime,
    required this.desc,
  });

  // Example: fromMap and toMap for Firebase integration
  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
    id: map['id'] ?? '',
    uid: map['uid'] ?? '',
    fullName: map['full_name'] ?? '',
    profilePicture: map['profile_picture'] ?? '',
    timestamp: map['timestamp'] ?? '',
    imageUrl: map['image_url'] ?? '',
    title: map['title'] ?? '',
    type: EventType.fromString(map['type']),
    address: map['address'] ?? '',
    dateRange: DateTimeRange(
      start: (map['date_start'] as Timestamp).toDate(),
      end: (map['date_end'] as Timestamp).toDate(),
    ),
    startTime: map['start_time'] ?? '',
    endTime: map['end_time'] ?? '',
    desc: map['desc'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'uid': uid,
    'full_name': fullName,
    'profile_picture': profilePicture,
    'timestamp': timestamp,
    'image_url': imageUrl,
    'title': title,
    'type': type.name,
    'address': address,
    'date_start': dateRange.start,
    'date_end': dateRange.end,
    'start_time': startTime,
    'end_time': endTime,
    'desc': desc,
  };

  // Dummy event image (optional)
  static const String dummyEventImage = "assets/images/placeholder_event.jpg";
}
