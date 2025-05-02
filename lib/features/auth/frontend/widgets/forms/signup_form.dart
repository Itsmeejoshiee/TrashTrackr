import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/core/widgets/buttons/auth_provider_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double formHeight = screenHeight * 0.80;
    print(formHeight);
    return Container(
      width: double.infinity,
      height: (formHeight < 600) ? formHeight + 200 : formHeight,
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

          Text('Sign up', style: kDisplaySmall),

          // Offset
          SizedBox(height: 25),

          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _firstNameController,
            hintText: 'First Name',
          ),
          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _lastNameController,
            hintText: 'Last Name',
          ),
          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _usernameController,
            iconData: Icons.alternate_email,
            hintText: 'Username',
          ),
          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _emailController,
            iconData: Icons.email,
            hintText: 'Email',
          ),
          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _passwordController,
            obscureText: true,
            iconData: Icons.lock,
            hintText: 'Password',
          ),
          ProfileTextField(
            margin: EdgeInsets.only(bottom: 15),
            controller: _confirmPasswordController,
            obscureText: true,
            iconData: Icons.lock,
            hintText: 'Confirm Password',
          ),

          // Dynamic Offset
          Flexible(child: SizedBox(height: 80)),

          RoundedRectangleButton(title: 'Sign up', onPressed: () {}),

          // Dynamic Offset
          Flexible(child: SizedBox(height: 40)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Text("Already have an account?", style: kBodyMedium),
              GestureDetector(
                onTap: widget.onToggle,
                child: Text(
                  'Sign in',
                  style: kBodyMedium.copyWith(
                    color: kAvocado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Dynamic Offset
          Flexible(child: SizedBox(height: 48)),

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

          // Dynamic Offset
          Flexible(child: SizedBox(height: 60)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              AuthProviderButton(
                padding: EdgeInsets.all(14),
                onPressed: () {},
                child: Image.asset('assets/images/google_green.png'),
              ),

              AuthProviderButton(
                padding: EdgeInsets.all(12),
                onPressed: () {},
                child: Image.asset('assets/images/facebook_green.png'),
              ),

              AuthProviderButton(
                padding: EdgeInsets.all(10),
                onPressed: () {},
                child: Image.asset('assets/images/apple_green.png'),
              ),
            ],
          ),

          // Dynamic Offset
          Flexible(child: SizedBox(height: 40)),

          // Offset
          SizedBox(height: 20)

        ],
      ),
    );
  }
}