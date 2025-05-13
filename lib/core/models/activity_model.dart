import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  ActivityModel({required this.activity, required this.timestamp});

  final String activity;
  final Timestamp timestamp;

  factory ActivityModel.fromMap(Map<String, dynamic> data) {
    return ActivityModel(
      activity: data['activity'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'activity': activity, 'timestamp': timestamp};
  }
}
