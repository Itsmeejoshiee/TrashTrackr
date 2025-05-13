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
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/user_provider.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/settings/backend/edit_profile_bloc.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';

class UserService {
  UserService(this.context);

  final BuildContext context;

  final AuthService _authService = AuthService();

  Future<UserModel?> createUserAccount({
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
      return null;
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(newUser);
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
      return null;
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

    // Update the user provider with the new user
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(newUser);
  }

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();

      // Update the user provider with the new user
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Fetch the user from Firestore
      await userProvider.loadUserFromFirestore(
        _authService.currentUser?.uid ?? '',
      );
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

      // Update the user provider with the new user
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Fetch the user from Firestore
      await userProvider.loadUserFromFirestore(
        _authService.currentUser?.uid ?? '',
      );
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  //delete user data and account
  Future<void> deleteUser() async {
    await _authService.deleteAccount();
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

  Future uploadProfileImage({
    required String uid,
    required Uint8List? image,
  }) async {
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile/$uid.jpg');

    try {
      await imageRef.putData(image);
      final downloadUrl = await imageRef.getDownloadURL();

      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(uid)
      //     .set({'profile_picture': downloadUrl});
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
