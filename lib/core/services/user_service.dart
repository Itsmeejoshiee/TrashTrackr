import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';

class UserService extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUserFromFirestore(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      notifyListeners();
    }
  }

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

      // Create a new user model
      final newUser = UserModel(
        uid: _authService.currentUser?.uid ?? '',
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      // Save the new user to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      // Update the user provider with the new user
      setUser(newUser);
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  // Function to create a user account using Google Sign-In
  Future<void> createUserGoogleAccount() async {
    await _authService.signInWithGoogle();

    //Chop off the first name and last name from the display name
    final displayName = _authService.currentUser?.displayName ?? '';
    final nameParts = displayName.trim().split(RegExp(r'\s+'));

    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final newUser = UserModel(
      uid: AuthService().currentUser?.uid ?? '',
      email: AuthService().currentUser?.email ?? '',
      firstName: firstName,
      lastName: lastName,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
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

      // Fetch the user from Firestore
      await loadUserFromFirestore(AuthService().currentUser?.uid ?? '');
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  //delete user data and account
  Future<void> deleteUserData(String email, String password) async {
    await _authService.deleteAccount(email: email, password: password);
  }

  Future<String?> getFullName() async {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) return null;

    try {
      // Fetch user document from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userDoc.data()!;
      final firstName = userData['first_name'] ?? '';
      final lastName = userData['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      return fullName;
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  Future<void> createPost(String body, String? imageUrl) async {
    final uid = AuthService().currentUser?.uid;
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
      final firstName = userData['firstName'] ?? '';
      final lastName = userData['lastName'] ?? '';
      final fullName = '$firstName $lastName'.trim();

      await FirebaseFirestore.instance.collection('posts').add({
        'uid': uid,
        'fullname': fullName,
        'date': DateTime.now(),
        'body': body,
        'image_url': imageUrl,
      });
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future uploadImage(String? directory, Uint8List? image) async {
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(
      '$directory/${DateTime.now().millisecondsSinceEpoch}.jpg',
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
}
