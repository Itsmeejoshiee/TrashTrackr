import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/providers/user_provider.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/features/auth/backend/auth_bloc.dart';

class UserService {
  final BuildContext context;
  UserService(this.context);

  Future<void> createUserAccount({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController usernameController,
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
      // Access the AuthBloc for signing up
      final authViewModel = Provider.of<AuthBloc>(context, listen: false);

      // Sign up the user
      await authViewModel.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Create a new user model
      final newUser = UserModel(
        uid: AuthService().currentUser?.uid ?? '',
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
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
    }
  }

  // Function to create a user account using Google Sign-In
  Future<void> createUserGoogleAccount() async {
    final authViewModel = Provider.of<AuthBloc>(context, listen: false);
    await authViewModel.signInWithGoogle();

    //Chop off the first name and last name from the display name
    final displayName = AuthService().currentUser?.displayName ?? '';
    final nameParts = displayName.trim().split(RegExp(r'\s+'));

    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final newUser = UserModel(
      uid: AuthService().currentUser?.uid ?? '',
      email: AuthService().currentUser?.email ?? '',
      username: AuthService().currentUser?.displayName ?? '',
      firstName: firstName,
      lastName: lastName,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  // Function to login user account
  Future<void> loginUserAccount({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Function(String?) setErrorMessage,
  }) async {
    // Clear any previous error
    setErrorMessage(null);

    try {
      // Access the AuthBloc for signing in
      final authViewModel = Provider.of<AuthBloc>(context, listen: false);

      // Sign in the user
      await authViewModel.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Fetch the user from Firestore
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserFromFirestore(
        AuthService().currentUser?.uid ?? '',
      );
    } catch (e) {
      setErrorMessage('An error occurred. Please try again.');
      print('Error: $e');
    }
  }
}
