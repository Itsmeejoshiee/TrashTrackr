import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/services/notif_service.dart';
import '../../features/comment/model/comment_model.dart';

class CommentService {

  // Add a new comment to a post
  Future<void> addComment(CommentModel comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User profile not found in Firestore');
      }

      final userData = userDoc.data()!;
      final firstName = userData['first_name'] ?? '';
      final lastName = userData['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      final profilePicture = userData['profile_picture'] ?? '';

      final rootCollection = comment.isForEvent ? 'events' : 'posts';
      final docRef = FirebaseFirestore.instance
          .collection(rootCollection)
          .doc(comment.postId)
          .collection('comments')
          .doc();

      final commentWithId = CommentModel(
        id: docRef.id,
        postId: comment.postId,
        uid: user.uid,
        fullName: fullName,
        profilePicture: profilePicture,
        content: comment.content,
        timestamp: comment.timestamp,
        isForEvent: comment.isForEvent,
      );

      await docRef.set(commentWithId.toMap());

      print('Comment added with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  // Stream the number of comments for a post or event
  Stream<int> getCommentCount(String postId, {required bool isForEvent}) {
    final rootCollection = isForEvent ? 'events' : 'posts';

    return FirebaseFirestore.instance
        .collection(rootCollection)
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<bool> _hasCurrentUserCommented({required bool isForEvent, required String id}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(false);
    }
    final userId = user.uid;

    final rootCollection = isForEvent ? 'events' : 'posts';

    return FirebaseFirestore.instance
        .collection(rootCollection)
        .doc(id)
        .collection('comments')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Fetch comments for a specific post
  Stream<List<CommentModel>> fetchCommentsForPost(String postId, {required bool isForEvent}) {
    try {
      final rootCollection = isForEvent ? 'events' : 'posts';
      final commentsRef = FirebaseFirestore.instance
          .collection(rootCollection)
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true);

      return commentsRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return CommentModel.fromMap(data, id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error fetching comments: $e');
      return Stream.error(e);
    }
  }
}
