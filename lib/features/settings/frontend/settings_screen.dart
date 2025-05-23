// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/core/widgets/text_fields/profile_text_field.dart';
import 'package:trashtrackr/features/about/frontend/about_screen.dart';
import 'package:trashtrackr/features/auth/backend/auth_manager.dart';
import 'package:trashtrackr/features/faqs/frontend/faq_screen.dart';
import 'package:trashtrackr/features/placeholder/delete_transition_screen.dart';
import 'package:trashtrackr/features/settings/frontend/edit_profile_screen.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/buttons/edit_profile_picture_button.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/list_tiles/setting_tile.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/list_tiles/setting_tile_group.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/list_tiles/switch_setting_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifsEnabled = true;

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Future<bool> checkUser() async {
    bool accountType = await _userService.isUserGoogle();

    return accountType;
  }

  Future<void> _logout() async {
    final googleSignIn = GoogleSignIn();

    try {
      // If Google user, sign out of Google too
      if (await checkUser()) {
        await googleSignIn.disconnect().catchError((e) {});
        await googleSignIn.signOut().catchError((e) {});
      }

      // Always sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Navigate back to AuthManager
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthManager()),
          (route) => false,
        );
      }
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  Future<void> _deleteAccount(String email, String password) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DeleteTransitionScreen()),
    );

    await Future.delayed(Duration(milliseconds: 300));

    await _userService.deleteUser(email, password);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthManager()),
      (r) => false,
    );
  }

  Future<void> _deleteGAccount() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DeleteTransitionScreen()),
    );

    await Future.delayed(Duration(milliseconds: 300));

    await _authService.deleteGUser();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthManager()),
        (r) => false,
      );
    }
  }

  void _logoutAlert() {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto log out?",
      desc: "Don't worry, we'll keep everything saved for when you return.",
      image: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Image.asset(
          "assets/images/icons/red_logout_icon.png",
          width: 90,
        ),
      ),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kRed,
          radius: BorderRadius.circular(30),
          onPressed: _logout,
          child: Text(
            'Logout',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

  void _deleteGAccountAlert() {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto delete your account?",
      desc:
          "We're sad to see you leave! Deleting your TrashTrackr account will permanently erase your data, including your streaks, badges, posts, and waste log.",
      image: Image.asset("assets/images/icons/red_delete_icon.png", width: 110),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kRed,
          radius: BorderRadius.circular(30),
          onPressed: () {
            _deleteGAccount();
          },
          child: Text(
            'Delete',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

  void _deleteAccountAlert(String email) {
    TextEditingController passwordController = TextEditingController();
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto delete your account?",
      desc:
          "We're sad to see you leave! Deleting your TrashTrackr account will permanently erase your data, including your streaks, badges, posts, and waste log.",
      image: Image.asset("assets/images/icons/red_delete_icon.png", width: 110),
      content: Column(
        children: [
          ProfileTextField(
            controller: passwordController,
            hintText: 'Password',
            iconData: Icons.lock,
            obscureText: true,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kRed,
          radius: BorderRadius.circular(30),
          onPressed: () {
            _deleteAccount(email.trim(), passwordController.text.trim());
          },
          child: Text(
            'Delete',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

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
              child: SingleChildScrollView(
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
                      '${user.firstName} ${user.lastName}',
                      style: kHeadlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Offset
                    SizedBox(height: 35),

                    SettingTileGroup(
                      children: [
                        SettingTile(
                          title: 'Edit Profile Details',
                          iconData: Icons.edit,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              ),
                        ),

                        SwitchSettingTile(
                          title: 'Notifications',
                          iconData: Icons.notifications,
                          value: _notifsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notifsEnabled = value;
                            });
                          },
                        ),

                        // Deleted Privacy Policy: PrivacyScreen()
                        SettingTile(
                          title: 'Help & FAQs',
                          iconData: Icons.help,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FaqScreen(),
                                ),
                              ),
                        ),
                        SettingTile(
                          title: 'About TrashTrackr',
                          iconData: Icons.info,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ),
                              ),
                        ),

                        SettingTile(
                          title: 'Logout',
                          iconData: Icons.logout,
                          color: kRed,
                          onTap: _logoutAlert,
                        ),
                      ],
                    ),

                    SizedBox(height: 120),

                    // Delete Account Butotn
                    RoundedRectangleButton(
                      backgroundColor: kRed,
                      title: 'Delete Account',
                      onPressed: () async {
                        if (await checkUser()) {
                          _deleteGAccountAlert();
                        } else {
                          _deleteAccountAlert(user.email);
                        }
                      },
                    ),
                    // Offset
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
