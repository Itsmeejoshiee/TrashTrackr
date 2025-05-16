import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/comment/model/comment_model.dart';

class CommentService {
  final CollectionReference postsCollection =
  FirebaseFirestore.instance.collection("posts");

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


  // Update an existing comment
  Future<void> updateComment(CommentModel comment) async {
    if (comment.id.isEmpty) {
      throw Exception('Comment ID is required for update');
    }

    try {
      final commentDoc = postsCollection
          .doc(comment.postId)
          .collection('comments')
          .doc(comment.id);

      await commentDoc.update(comment.toMap());
      print('Comment updated with ID: ${comment.id}');
    } catch (e) {
      print('Error updating comment: $e');
      rethrow;
    }
  }

  // Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final commentDoc = postsCollection
          .doc(postId)
          .collection('comments')
          .doc(commentId);

      await commentDoc.delete();
      print('Comment deleted with ID: $commentId');
    } catch (e) {
      print('Error deleting comment: $e');
      rethrow;
    }
  }
}
