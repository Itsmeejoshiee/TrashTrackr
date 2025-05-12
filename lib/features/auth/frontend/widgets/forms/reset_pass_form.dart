import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';

class ResetPassForm extends StatefulWidget {
  const ResetPassForm({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<ResetPassForm> createState() => _ResetPassFormState();
}

class _ResetPassFormState extends State<ResetPassForm> {
  final TextEditingController _emailController = TextEditingController();
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

          Text('Reset Password', style: kDisplaySmall),

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

          Flexible(child: SizedBox(height: 80)),

          RoundedRectangleButton(
            title: 'Reset Password',
            onPressed: () async {
              final authService = Provider.of<AuthService>(
                context,
                listen: false,
              );
              await authService.resetPassword(email: _emailController.text);
            },
          ),
          Flexible(child: SizedBox(height: 60)),
        ],
      ),
    );
  }
}
