import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/utils/auth_state.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/backend/auth_bloc.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/profile/frontend/profile_page.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthBloc>(context);

    switch (authViewModel.authState) {
      case AuthState.waiting:
        //idk what to do here
        return WelcomeScreen();
      case AuthState.signup:
        //idk what to do here
        return WelcomeScreen();
      case AuthState.login:
        //idk what to do here
        return WelcomeScreen();
      case AuthState.authenticated:
        return ProfilePage();
      case AuthState.unauthenticated:
        return WelcomeScreen();
    }
  }
}
