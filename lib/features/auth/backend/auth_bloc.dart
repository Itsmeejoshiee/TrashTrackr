import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/utils/auth_state.dart';

class AuthBloc extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthState _authState = AuthState.waiting;
  User? _user;

  AuthBloc() {
    _initializeAuthState();
  }

  AuthState get authState => _authState;
  User? get user => _user;

  Future<void> _initializeAuthState() async {
    _user = _authService.currentUser;
    if (_user != null) {
      _authState = AuthState.authenticated;
    } else {
      _authState = AuthState.login;
    }
    notifyListeners();
  }

  Future<void> showLogin() async {
    _authState = AuthState.login;
    notifyListeners();
  }

  Future<void> showSignup() async {
    _authState = AuthState.signup;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authService.createAccount(email, password);
    _user = _authService.currentUser;
    _authState =
        _user != null ? AuthState.authenticated : AuthState.unauthenticated;
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _authState = AuthState.login;
    _user = null;
    notifyListeners();
  }
}
