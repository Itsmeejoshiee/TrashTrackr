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

  // Sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  //reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
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

  //Delete account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      // Re-authenticate the user before deleting the account
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  //reset Password
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
}
