import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/auth_state.dart';
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

  AuthState _authState = AuthState.waiting;

  void _scrollListener() {
    if (_scrollController.offset < _scrollLockThreshold) {
      _scrollController.jumpTo(_scrollLockThreshold);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    _scrollLockThreshold = screenHeight * 0.60;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          controller: _scrollController,
          // physics:
          //     (_authState == AuthState.waiting)
          //         ? ClampingScrollPhysics()
          //         : NeverScrollableScrollPhysics(),
          physics: ClampingScrollPhysics(),
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
              (_authState == AuthState.waiting)
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        AuthButton(
                          title: 'Login',
                          onPressed: () {
                            setState(() => _authState = AuthState.login);
                            _scrollController.animateTo(
                              800,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                        ),

                        // Offset
                        const SizedBox(height: 10),

                        AuthButton(
                          title: 'Sign up',
                          onPressed: () {
                            setState(() => _authState = AuthState.signup);
                            _scrollController.animateTo(
                              800,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                        ),

                        // Dynamic Offset
                        SizedBox(height: 30),
                      ],
                    ),
                  )
                  : (_authState == AuthState.login)
                  ? LoginForm(
                    onToggle: () {
                      setState(() => _authState = AuthState.signup);
                    },
                  )
                  : SignupForm(
                    onToggle: () {
                      setState(() => _authState = AuthState.login);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
