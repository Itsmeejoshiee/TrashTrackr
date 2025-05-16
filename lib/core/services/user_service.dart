import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashtrackr/core/models/activity_model.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/user_provider.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  final AuthService _authService = AuthService();
  final BadgeService _badgeService = BadgeService();

  Future<void> createUserAccount({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required Function(String?) setErrorMessage,
  }) async {
    // Clear any previous error
    setErrorMessage(null);

    // Validate passwords
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setErrorMessage('Passwords do not match.');
      return;
    }

    try {
      // Sign up the user
      await _authService.createAccount(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final uid = _authService.currentUser?.uid;

      // Create a new user model
      final newUser = UserModel(
        uid: uid ?? '',
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        profilePicture: '',
        followerCount: 0,
        followingCount: 0,
      );

      // Save the new user to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      await _badgeService.initUserBadges();
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
      return null;
    }
  }

  Future<bool> doesUserDocumentExist(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final docSnapshot = await docRef.get();

    return docSnapshot.exists; // true if document exists, false otherwise
  }

  // Function to create a user account using Google Sign-In
  Future<void> createUserGoogleAccount() async {
    await _authService.signInWithGoogle();

    final uid = _authService.currentUser?.uid;

    //Chop off the first name and last name from the display name
    final displayName = _authService.currentUser?.displayName ?? '';
    final nameParts = displayName.trim().split(RegExp(r'\s+'));

    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    final profilePicture = getGUserProfilePicture();
    final newUser = UserModel(
      uid: uid ?? '',
      email: _authService.currentUser?.email ?? '',
      firstName: firstName,
      lastName: lastName,
      profilePicture: (await profilePicture) ?? '',
      followerCount: 0,
      followingCount: 0,
    );

    await _badgeService.initUserBadges();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  Future<bool> isUserGoogle() async {
    final user = _authService.currentUser;
    if (user == null) {
      return false;
    } else {
      return user.providerData.any((info) => info.providerId == 'google.com');
    }
  }

  Future<String?> getGUserProfilePicture() async {
    final uid = _authService.currentUser?.uid;
    final user = _authService.currentUser;
    if (uid == null) {
      print('User is null, cannot fetch profile picture');
      return '';
    }

    try {
      final profilePicture = user!.photoURL;
      return profilePicture;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return '';
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      final uid = _authService.currentUser?.uid;
      final docExists = await doesUserDocumentExist(uid!);
      if (!docExists) {
        final displayName = _authService.currentUser?.displayName ?? '';
        final nameParts = displayName.trim().split(RegExp(r'\s+'));

        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        final profilePicture = getGUserProfilePicture();
        final newUser = UserModel(
          uid: uid,
          email: _authService.currentUser?.email ?? '',
          firstName: firstName,
          lastName: lastName,
          profilePicture: (await profilePicture) ?? '',
          followerCount: 0,
          followingCount: 0,
        );

        await _badgeService.initUserBadges();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to login user account
  Future<void> loginUserAccount({
    required String email,
    required String password,
    required Function(String?) setErrorMessage,
  }) async {
    // Clear any previous error
    setErrorMessage(null);

    try {
      // Sign in the user
      await _authService.signIn(email, password);
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  //delete user data and account
  Future<void> deleteUser(String email, String password) async {
    await _authService.deleteAccount(email: email, password: password);
  }

  //retrieves a stream of document
  Stream<UserModel?> getUserStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch user stream');
      return Stream.value(null);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            print('Snapshot exists.');
            print(snapshot.data());
            return UserModel.fromMap(snapshot.data()!);
          } else {
            print('User document does not exist');
            return null;
          }
        });
  }

  Future<void> updateUserInfo(String fieldName, String value) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        fieldName: value,
      });
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<void> logActivity(String activity) async {
    final uid = _authService.currentUser?.uid;
    final activityModel = ActivityModel(
      activity: activity,
      timestamp: Timestamp.now(),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_log')
        .add(activityModel.toMap());
  }

  Stream<List<ActivityModel>> getActivityStream() {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch activity stream');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('activity_log')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ActivityModel.fromMap(doc.data());
          }).toList();
        });
  }

  Future<void> createPost(PostModel post) async {
    final uid = _authService.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(uid)
        .set(post.toMap());
  }

  Future<void> createEvent(EventModel event) async {
    await FirebaseFirestore.instance.collection('events').add(event.toMap());
  }

  Future uploadProfileImage(Uint8List? image) async {
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final uid = _authService.currentUser!.uid;
    final imageRef = storageRef.child('profile/$uid.jpg');

    try {
      await imageRef.putData(image);
      final downloadUrl = await imageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profile_picture': downloadUrl,
      });
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<UserModel?> getUser() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      print('UID is null, cannot fetch profile picture');
      return null;
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final user = UserModel.fromMap(userDoc.data()!);
      return user;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return null;
    }
  }

  Future<void> incrementFollowingCount() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      print('UID is null, cannot fetch profile picture');
      return null;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'following_count': FieldValue.increment(1),
    });
  }

  // Waste Log Counter
  Future<Map<String, int>?> countDisposalClassifications() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      print('UID is null, cannot fetch profile picture');
      return null;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('log_disposal')
        .get();

    final Map<String, int> counts = {
      'Recyclable': 0,
      'Biodegradable': 0,
      'Non-biodegradable': 0,
    };

    for (final doc in snapshot.docs) {
      final classification = doc['classification'] as String?;
      if (classification != null && counts.containsKey(classification)) {
        counts[classification] = counts[classification]! + 1;
      }
    }
    return counts;
  }

}
