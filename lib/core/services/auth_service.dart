import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //initialize firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //gets the current user
  User? get currentUser => firebaseAuth.currentUser;

  //returns information if user is logged in or not
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  //create account with email and password
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
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
}
