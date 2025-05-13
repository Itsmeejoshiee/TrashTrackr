import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/about/frontend/about_screen.dart';
import 'package:trashtrackr/features/auth/backend/auth_manager.dart';
import 'package:trashtrackr/features/faqs/frontend/faq_screen.dart';
import 'package:trashtrackr/features/settings/backend/profile_picture.dart';
import 'package:trashtrackr/features/settings/frontend/edit_profile_screen.dart';
import 'package:trashtrackr/features/settings/frontend/privacy_screen.dart';
import 'package:trashtrackr/features/settings/frontend/widgets/buttons/edit_profile_picture_button.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'widgets/list_tiles/setting_tile.dart';
import 'widgets/list_tiles/switch_setting_tile.dart';
import 'widgets/list_tiles/setting_tile_group.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifsEnabled = true;

  final AuthService _authService = AuthService();

  Future<void> _logout() async {
    // Sign Out
    await _authService.signOut();

    // Navigate back to AuthManager and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthManager()),
      (r) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final userService = UserService(context);
    await userService.deleteUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthManager()),
      (r) => false,
    );
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

  void _deleteAccountAlert() {
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
            _deleteAccount();
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
                onPressed: () async {
                  final profilePicture = ProfilePicture();
                  await profilePicture.update(context);
                },
              ),

              Text(
                'Ella Green',
                style: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              // Offset
              Flexible(child: SizedBox(height: 35)),

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

                  SettingTile(
                    title: 'Privacy Options',
                    iconData: Icons.shield,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyScreen(),
                          ),
                        ),
                  ),

                  SettingTile(
                    title: 'Help & FAQs',
                    iconData: Icons.help,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FaqScreen()),
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

              // Flexible Offset
              Flexible(child: SizedBox(height: 120)),

              // Delete Account Butotn
              RoundedRectangleButton(
                backgroundColor: kRed,
                title: 'Delete Account',
                onPressed: _deleteAccountAlert,
              ),

              // Offset
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
