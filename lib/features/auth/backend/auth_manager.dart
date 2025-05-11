import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/utils/auth_state.dart';
import 'package:trashtrackr/features/auth/backend/auth_bloc.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthBloc>(context);

    switch (authViewModel.authState) {
      case AuthState.welcome:
        return WelcomeScreen();
      case AuthState.authenticated:
        return DashboardScreen();
      case AuthState.unauthenticated:
        return WelcomeScreen();
    }
  }
}
