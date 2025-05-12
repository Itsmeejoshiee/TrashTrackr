import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/core/widgets/buttons/auth_provider_button.dart';
import 'package:trashtrackr/features/auth/backend/auth_bloc.dart';

import '../../../../dashboard/frontend/dashboard_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double formHeight = screenHeight * 0.80;
    return Container(
      width: double.infinity,
      height: formHeight + 20,
      padding: EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // Offset
          SizedBox(height: 30),

          Text('Login', style: kDisplaySmall),

          // Offset
          SizedBox(height: 10),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                _errorMessage!,
                style: kLabelLarge.copyWith(color: Colors.red),
              ),
            ),
          ProfileTextField(
            controller: _emailController,
            iconData: Icons.email,
            hintText: 'Email',
          ),
          ProfileTextField(
            controller: _passwordController,
            obscureText: true,
            iconData: Icons.lock,
            hintText: 'Password',
          ),

          // Password Reset Button
          GestureDetector(
            child: Text(
              'Forgot Password?',
              style: kBodyMedium.copyWith(color: kAvocado),
            ),
          ),

          Flexible(child: SizedBox(height: 80)),

          RoundedRectangleButton(
            title: 'Login',
            onPressed: () async {
              final UserService userService = UserService(context);
              await userService.loginUserAccount(
                emailController: _emailController,
                passwordController: _passwordController,
                setErrorMessage: (message) {
                  setState(() {
                    _errorMessage = message;
                  });
                },
              );
            },
          ),

          Flexible(child: SizedBox(height: 60)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Text("Don't have an account?", style: kBodyMedium),
              GestureDetector(
                onTap: widget.onToggle,
                child: Text(
                  'Sign up',
                  style: kBodyMedium.copyWith(
                    color: kAvocado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          Flexible(child: SizedBox(height: 60)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container(height: 1, color: Colors.black)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text('Or'),
              ),
              Expanded(child: Container(height: 1, color: Colors.black)),
            ],
          ),

          Flexible(child: SizedBox(height: 60)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              //Google Sign In Button
              AuthProviderButton(
                padding: EdgeInsets.all(14),
                onPressed: () async {
                  final authViewModel = Provider.of<AuthBloc>(
                    context,
                    listen: false,
                  );
                  await authViewModel.signInWithGoogle();
                },
                child: Image.asset('assets/images/icons/google_green.png'),
              ),

              AuthProviderButton(
                padding: EdgeInsets.all(12),
                onPressed: () {},
                child: Image.asset('assets/images/icons/facebook_green.png'),
              ),

              AuthProviderButton(
                padding: EdgeInsets.all(10),
                onPressed: () {},
                child: Image.asset('assets/images/icons/apple_green.png'),
              ),
            ],
          ),

          Flexible(child: SizedBox(height: 60)),
        ],
      ),
    );
  }
}
