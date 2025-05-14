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
import 'package:trashtrackr/features/post/models/post_entry.dart';
import 'package:trashtrackr/features/settings/backend/edit_profile_bloc.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';

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

  // Function to create a user account using Google Sign-In
  Future<void> createUserGoogleAccount() async {
    await _authService.signInWithGoogle();

    final uid = _authService.currentUser?.uid;

    //Chop off the first name and last name from the display name
    final displayName = _authService.currentUser?.displayName ?? '';
    final nameParts = displayName.trim().split(RegExp(r'\s+'));

    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final newUser = UserModel(
      uid: uid ?? '',
      email: _authService.currentUser?.email ?? '',
      firstName: firstName,
      lastName: lastName,
      profilePicture: '',
      followerCount: 0,
      followingCount: 0,
    );

    await _badgeService.initUserBadges();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
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

  //TODO: Optimize this function, loads slowly. I think im using shared prefs wrong way.

  Future<String?> getFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      print('UID is null, cannot fetch full name');
      return null;
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDoc.data();

      if (userData == null) {
        print('User document not found for UID: $uid');
        return null;
      }

      final firstName = userData['first_name'] ?? '';
      final lastName = userData['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();

      final cachedFullName = prefs.getString('fullName');
      if (cachedFullName != fullName) {
        await prefs.setString('fullName', fullName);
        print('Full name updated in SharedPreferences: $fullName');
      } else {
        print('No Updates in SharedPreferences.');
      }
      return cachedFullName;
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  // fieldnames: first_name, last_name, email
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

  /*
  Future<void> createPost(String body, String? imageUrl, String? emotion) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    try {
      // Fetch user document from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        print('User document not found');
        return;
      }

      final userData = userDoc.data()!;
      final firstName = userData['first_name'] ?? '';
      final lastName = userData['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();

      await FirebaseFirestore.instance.collection('posts').add({
        'uid': uid,
        'full_name': fullName,
        'date': DateTime.now(),
        'body': body,
        'image_url': imageUrl,
        'emotion': emotion
      });
    } catch (e) {
      print('Error creating post: $e');
    }
  }
  Future<void> createEvent(String imageUrl, String eventType,
      DateTimeRange dateRange, String eventDescription) async {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'uid': uid,
        'image_url': imageUrl,
        'event_type': eventType,
        'date_range': dateRange,
        'event_description': eventDescription,
      });
    } catch (e) {
      print('Error creating event: $e');
    }
  }
*/
  Future<void> createPost(PostEntry post) async {
    final uid = _authService.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(uid)
        .set(post.toMap());
  }

  Future<void> createEvent(EventEntry event) async {
    await FirebaseFirestore.instance.collection('events').add(event.toMap());
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

  Future<String?> getProfilePicture() async {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) {
      print('UID is null, cannot fetch profile picture');
      return null;
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDoc.data();
      if (userData == null) {
        print('User document not found for UID: $uid');
        return null;
      }
      return userData['profile_picture'] as String?;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return null;
    }
  }
}
