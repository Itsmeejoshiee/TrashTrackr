import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/core/widgets/buttons/auth_provider_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onToggle,
    required this.onForgotPassword,
  });

  final VoidCallback onToggle;
  final VoidCallback onForgotPassword;

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
            onTap: widget.onForgotPassword,
          ),

          Flexible(child: SizedBox(height: 80)),

          RoundedRectangleButton(
            title: 'Login',
            onPressed: () async {
              final UserService userService = UserService();
              await userService.loginUserAccount(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
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
                  final userService = UserService();
                  await userService.signInWithGoogle();
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
