import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/user_model.dart';

class FirestoreService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create new user (userId is auto-generated)
  Future<void> createUser(String userId, UserModel user) async {
    await _firestore.collection('users').doc(userId).set(user.toMap());
  }

  // Get user data
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  // Update user information
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(userId).update(updates);
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

}