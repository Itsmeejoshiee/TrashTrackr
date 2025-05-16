// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //initialize firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //gets the current user
  User? get currentUser => firebaseAuth.currentUser;

  //returns information if user is logged in or not
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  //create account with email and password
  Future<UserCredential> createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is invalid.');
      } else if (e.code == 'operation-not-allowed') {
        print(
          'Email/Password accounts are not enabled. Enable them in the Firebase Console.',
        );
      } else {
        print('Error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw Exception('Error signing in: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  //reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      rethrow;
    }
  }

  //update username
  Future<void> updateUserName({required String username}) async {
    try {
      await currentUser!.updateProfile(displayName: username);
    } catch (e) {
      rethrow;
    }
  }

  //To do: test this function
  //Delete account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        print('No user is currently signed in.');
        return;
      }
      // Re-authenticate the user before deleting the account
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);

      try {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        final posts =
            await FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: user.uid)
                .get();
        final events =
            await FirebaseFirestore.instance
                .collection('events')
                .where('uid', isEqualTo: user.uid)
                .get();
        final allDocs = [...posts.docs, ...events.docs];

        for (final doc in allDocs) {
          await doc.reference.delete();
        }
      } catch (e) {
        print('Error deleting user data: $e');
      }

      await currentUser!.delete();
      await firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  //Delete Google account
  Future<void> deleteGUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final AuthService authService = AuthService();
    final User? user = authService.currentUser;

    if (user == null) {
      print('No current user found.');
      return;
    }

    try {
      // Option 1: Attempt to re-authenticate if necessary (adjust logic as needed)
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in cancelled by user.');
        return;
      }
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Failed to obtain Google authentication credentials.');
        return;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      print('User successfully reauthenticated.');

      // Option 2: If re-signing in isn't needed, you might directly proceed
      // without the GoogleSignIn part if the user is already authenticated.
      // In that case, ensure robust error handling for reauthenticateWithCredential.

      try {
        final String? uid = user.uid;
        if (uid != null) {
          // Delete user data from Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .delete();
          print('User document deleted.');

          // Delete associated posts
          final posts =
              await FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: uid)
                  .get();
          for (final doc in posts.docs) {
            await doc.reference.delete();
          }
          print('${posts.docs.length} posts deleted.');

          // Delete associated events
          final events =
              await FirebaseFirestore.instance
                  .collection('events')
                  .where('uid', isEqualTo: uid)
                  .get();
          for (final doc in events.docs) {
            await doc.reference.delete();
          }
          print('${events.docs.length} events deleted.');
        } else {
          print('Error: User UID is null.');
          return;
        }
      } catch (firestoreError) {
        print('Error deleting user data from Firestore: $firestoreError');
        // Consider if you want to stop the process here or try to delete the Auth user anyway.
        return;
      }

      // Delete the Firebase Auth user
      await user.delete();
      print('Firebase Auth user deleted successfully.');

      // Optionally sign out of Google after deletion
      await googleSignIn.signOut();
      print('Signed out of Google.');
    } on FirebaseAuthException catch (authError) {
      print(
        'Firebase Auth error during reauthentication or deletion: ${authError.message}',
      );
      // Handle specific Firebase Auth errors (e.g., wrong password, requires recent login)
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    //Get user profile (for testin purposes)
    Future<void> getUserProfile() async {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          print(user.uid);
        } else {
          print('User is currently signed out!');
        }
      });
    }

    //reset Password (when signed in)
    Future<void> resetPasswordFromCurrentPassword({
      required String currentPassword,
      required String newPassword,
    }) async {
      try {
        // Re-authenticate the user before updating the password
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser!.email!,
          password: currentPassword,
        );
        await currentUser!.reauthenticateWithCredential(credential);
        await currentUser!.updatePassword(newPassword);
      } catch (e) {
        rethrow;
      }
    }
  }
}
