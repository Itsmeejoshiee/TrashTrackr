import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/buttons/edit_profile_picture_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lasttNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final UserService _userService = UserService();
  bool _controllersInitialized = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.getUserStream(),
      builder: (context, snapshot) {
        print('SNAPSHOT DATA');
        print(snapshot.data);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('User data is not available.'));
        }

        final user = snapshot.data;

        // Initialize the controllers only once
        if (!_controllersInitialized) {
          _firstNameController.text = user!.firstName;
          _lasttNameController.text = user.lastName;
          _emailController.text = user.email;
          _controllersInitialized = true;
        }

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
                  EditProfilePictureButton(
                    image:
                        (user!.profilePicture.isNotEmpty)
                            ? NetworkImage(user.profilePicture)
                            : AssetImage(
                              'assets/images/placeholder_profile.jpg',
                            ),
                    onPressed: () async {
                      final profilePicture = ProfilePicture();
                      await profilePicture.update(context);
                    },
                  ),

                  Text(
                    '${user!.firstName} ${user.lastName}',
                    style: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  Flexible(child: SizedBox(height: 72)),

                  ProfileTextField(
                    controller: _emailController,
                    iconData: Icons.email,
                    hintText: 'Email Address',
                    enabled: false,
                  ),

                  ProfileTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                  ),

                  ProfileTextField(
                    controller: _lasttNameController,
                    hintText: 'Last Name',
                  ),

                  // Flexible Offset
                  Flexible(child: SizedBox(height: 55)),

                  // Save Account Button
                  RoundedRectangleButton(
                    title: 'Save',
                    onPressed: () async {
                      final UserService userService = UserService();

                      if (_firstNameController.text != user.firstName) {
                        await userService.updateUserInfo(
                          'first_name',
                          _firstNameController.text,
                        );
                      }

                      if (_lasttNameController.text != user.lastName) {
                        await userService.updateUserInfo(
                          'last_name',
                          _lasttNameController.text,
                        );
                      }
                    },
                  ),

                  // Offset
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
