import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:trashtrackr/core/utils/emotion.dart';
import 'package:trashtrackr/core/utils/event_type.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';

class PostService {
  final AuthService _authService = AuthService();

  Future<void> createPost({
    required UserModel user,
    required String body,
    required Emotion emotion,
    Uint8List? image,
  }) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    try {
      // Fetch user document from Firestore

      final firstName = user.firstName;
      final lastName = user.lastName;
      final fullName = '$firstName $lastName'.trim();
      final profilePicture = user.profilePicture;
      final imageUrl = (image == null) ? '' : await uploadPostImage(image);

      final post = PostModel(
        uid: uid,
        fullName: fullName,
        profilePicture: profilePicture,
        timestamp: Timestamp.now(),
        emotion: emotion,
        body: body,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance.collection('posts').add(post.toMap());
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future<void> createEvent({
    required UserModel user,
    Uint8List? image,
    required String title,
    required EventType type,
    required String address,
    required DateTimeRange dateRange,
    required String startTime,
    required String endTime,
    required String desc,
  }) async {
    try {
      final uid = AuthService().currentUser?.uid;
      if (uid == null) return;

      final firstName = user.firstName;
      final lastName = user.lastName;
      final fullName = '$firstName $lastName'.trim();
      final profilePicture = user.profilePicture;
      final imageUrl = (image == null) ? '' : await uploadPostImage(image);

      final event = EventModel(
        uid: uid,
        fullName: fullName,
        profilePicture: profilePicture,
        timestamp: Timestamp.now(),
        imageUrl: imageUrl,
        title: title,
        type: type,
        address: address,
        dateRange: dateRange,
        startTime: startTime,
        endTime: endTime,
        desc: desc,
      );

      await FirebaseFirestore.instance.collection('events').add(event.toMap());
    } catch (e) {
      print('Error creating event: $e');
    }
  }

  Future uploadPostImage(Uint8List? image) async {
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(
      'posts/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    try {
      await imageRef.putData(image);
      final downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Stream<List<PostModel>> getPostStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch post stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance.collection('posts').snapshots().map((
      snapshot,
    ) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<EventModel>> getEventStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch event stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance.collection('events').snapshots().map((
      snapshot,
    ) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<EventModel>> getUpcomingEventStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch event stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('events')
        .where('date_start', isGreaterThan: Timestamp.now())
        .snapshots()
        .map((snapshot) {
          print('SNAPSHOT DOCS!');
          print(snapshot.docs);
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList();
        });
  }

  Stream<List<EventModel>> getPastEventStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch event stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('events')
        .where('date_start', isLessThan: Timestamp.now())
        .snapshots()
        .map((snapshot) {
      print('SNAPSHOT DOCS!');
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data());
      }).toList();
    });
  }
}
