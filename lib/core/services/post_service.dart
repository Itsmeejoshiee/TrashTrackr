import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:trashtrackr/core/utils/emotion.dart';
import 'package:trashtrackr/core/utils/event_type.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';

class PostService {
  final AuthService _authService = AuthService();

  Future<void> createPost({
    required UserModel user,
    required String body,
    required Emotion emotion,
    Uint8List? image,
  }) async {
    // get the post ID
    final docRef = FirebaseFirestore.instance.collection('posts').doc();
    final docId = docRef.id;

    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    try {
      final firstName = user.firstName;
      final lastName = user.lastName;
      final fullName = '$firstName $lastName'.trim();
      final profilePicture = user.profilePicture;
      final imageUrl =
          (image == null) ? '' : (await uploadPostImage(image) ?? '');

      final post = PostModel(
        id: docId,
        uid: uid,
        fullName: fullName,
        profilePicture: profilePicture,
        timestamp: Timestamp.now(),
        emotion: emotion,
        body: body,
        imageUrl: imageUrl,
      );

      await docRef.set(post.toMap());
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
      final imageUrl =
          (image == null) ? '' : (await uploadPostImage(image) ?? '');

      final event = EventModel(
        id: '',
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

  Future<String?> uploadPostImage(Uint8List? image) async {
    if (image == null) return null;

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
        final post = PostModel.fromMap(doc.data()).copyWith(id: doc.id);
        return post;
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
        final event = EventModel.fromMap(doc.data()).copyWith(id: doc.id);
        return event;
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
          print(snapshot.docs);
          return snapshot.docs.map((doc) {
            final event = EventModel.fromMap(doc.data()).copyWith(id: doc.id);
            return event;
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
          print(snapshot.docs);
          return snapshot.docs.map((doc) {
            final event = EventModel.fromMap(doc.data()).copyWith(id: doc.id);
            return event;
          }).toList();
        });
  }

  Stream<List<PostModel>> getPostResultStream({required String searchKeyword}) {
    final keywordLower = searchKeyword.toLowerCase();

    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => PostModel.fromMap(doc.data(), id: doc.id),
              ) // <-- Pass doc.id here
              .where((post) => post.body.toLowerCase().contains(keywordLower))
              .toList();
        });
  }

  // Post Liking Methods
  Future<void> likePost(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> unlikePost(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .delete();
  }

  Future<bool> isPostLikedByUser(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(uid)
            .get();
    return doc.exists;
  }

  Stream<int> getPostLikeCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Stream<bool> postLikedByCurrentUserStream(String postId) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Like Event Methods
  Future<void> likeEvent(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('likes')
        .doc(uid)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> unlikeEvent(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('likes')
        .doc(uid)
        .delete();
  }

  Future<bool> isEventLikedByUser(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .collection('likes')
            .doc(uid)
            .get();
    return doc.exists;
  }

  Stream<int> getEventLikeCount(String eventId) {
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('likes')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Stream<bool> eventLikedByCurrentUserStream(String eventId) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('likes')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Bookmark Post

  Future<void> bookmarkPost(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('post_$postId')
        .set({
          'type': 'post',
          'postId': postId,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> unbookmarkPost(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('post_$postId')
        .delete();
  }

  // Bookmark Event

  Future<void> bookmarkEvent(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('event_$eventId')
        .set({
          'type': 'event',
          'eventId': eventId,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> unbookmarkEvent(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('event_$eventId')
        .delete();
  }

  // Post & Event Bookmark Check

  Future<bool> isPostBookmarked(String postId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('bookmarks')
            .doc('post_$postId')
            .get();
    return doc.exists;
  }

  Future<bool> isEventBookmarked(String eventId) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('bookmarks')
            .doc('event_$eventId')
            .get();
    return doc.exists;
  }

  Stream<bool> postBookmarkedStream(String postId) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('post_$postId')
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<bool> eventBookmarkedStream(String eventId) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc('event_$eventId')
        .snapshots()
        .map((doc) => doc.exists);
  }
}
