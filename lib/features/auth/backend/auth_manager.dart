import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/utils/auth_state.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';

class AuthManager extends StatelessWidget {
  AuthManager({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DashboardScreen();
        } else {
          return WelcomeScreen();
        }
      },
    );
  }
}
