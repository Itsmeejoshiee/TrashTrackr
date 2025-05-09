import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/buttons/edit_profile_picture_button.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lasttNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Settings',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Edit Profile Picture
              EditProfilePictureButton(onPressed: () {}),

              Text(
                'Ella Green',
                style: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              Flexible(child: SizedBox(height: 72)),

              ProfileTextField(controller: _firstNameController),

              ProfileTextField(controller: _lasttNameController),

              ProfileTextField(
                controller: _usernameController,
                iconData: Icons.alternate_email,
              ),

              ProfileTextField(
                controller: _emailController,
                iconData: Icons.email,
              ),

              // Flexible Offset
              Flexible(child: SizedBox(height: 55)),

              // Delete Account Butotn
              RoundedRectangleButton(title: 'Save', onPressed: () {}),

              // Offset
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
