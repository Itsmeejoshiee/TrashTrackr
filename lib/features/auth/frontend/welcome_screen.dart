import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/auth_form_view.dart';
import 'package:trashtrackr/features/auth/frontend/widgets/forms/reset_pass_form.dart';
import 'widgets/leaf_wall.dart';
import 'package:trashtrackr/core/widgets/buttons/auth_button.dart';
import 'widgets/forms/signup_form.dart';
import 'widgets/forms/login_form.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollLockThreshold = 400;
  double _scrollHeight = 400;
  bool _lockScroll = false;

  AuthFormView _authFormView = AuthFormView.waiting;

  // Locks scrolling past the scroll lock threshold
  void _scrollListener() {
    if (_lockScroll && _scrollController.offset < _scrollLockThreshold) {
      _scrollController.jumpTo(_scrollLockThreshold);
    }
  }

  void _scrollDown(double height) async {
    await _scrollController.animateTo(
      height,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    setState(() => _lockScroll = true);
  }

  Widget _buildForm(AuthFormView view) {
    switch (view) {
      case AuthFormView.login:
        return LoginForm(
          onToggle: () {
            setState(() => _authFormView = AuthFormView.signup);
          },
          onForgotPassword: () {
            setState(() => _authFormView = AuthFormView.resetPassword);
          },
        );
      case AuthFormView.signup:
        return SignupForm(
          onToggle: () {
            setState(() => _authFormView = AuthFormView.login);
          },
        );
      case AuthFormView.resetPassword:
        return ResetPassForm(onToggle: () {
          setState(() => _authFormView = AuthFormView.login);
        });
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              AuthButton(
                title: 'Login',
                onPressed: () async {
                  setState(() => _authFormView = AuthFormView.login);
                  _scrollDown(_scrollHeight);
                },
              ),

              // Offset
              const SizedBox(height: 10),

              AuthButton(
                title: 'Sign up',
                onPressed: () async {
                  setState(() => _authFormView = AuthFormView.signup);
                  _scrollDown(_scrollHeight);
                },
              ),

              // Dynamic Offset
              SizedBox(height: 30),
            ],
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically resize scrollLockThreshold to screen height
    final double screenHeight = MediaQuery.of(context).size.height;
    _scrollLockThreshold = screenHeight * 0.60;
    _scrollHeight = screenHeight * 0.60;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics:
            (_authFormView != AuthFormView.waiting)
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
        // physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            // Leaf Wall Image
            LeafWall(height: screenHeight),

            // Welcome Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hello!',
                    style: kDisplaySmall.copyWith(color: Colors.white),
                  ),

                  RichText(
                    text: TextSpan(
                      style: kTitleLarge.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(text: 'Welcome to '),
                        TextSpan(
                          text: 'TrashTrackr',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Login & Signup Button
            _buildForm(_authFormView),
          ],
        ),
      ),

      // Make bottom safe area white
      bottomNavigationBar: Builder(
        builder: (context) {
          final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
          return bottomPadding > 0
              ? Container(
                height: bottomPadding,
                color:
                    (_authFormView != AuthFormView.waiting)
                        ? Colors.white
                        : Theme.of(context).primaryColor,
              )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
