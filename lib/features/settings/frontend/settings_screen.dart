import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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

  void _logout() {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto log out?",
      desc: "Don't worry, we'll keep everything saved for when you return.",
      image: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Image.asset("assets/images/red_logout_icon.png", width: 90),
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
          onPressed: () {},
          child: Text(
            'Logout',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

  void _deleteAccount() {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto delete your account?",
      desc:
          "We're sad to see you leave! Deleting your TrashTrackr account will permanently erase your data, including your streaks, badges, posts, and waste log.",
      image: Image.asset("assets/images/red_delete_icon.png", width: 110),
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
          onPressed: () {},
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
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
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

              // Offset
              Flexible(child: SizedBox(height: 35)),

              SettingTileGroup(
                children: [
                  SettingTile(
                    title: 'Edit Profile Details',
                    iconData: Icons.edit,
                    onTap: () {},
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
                    onTap: () {},
                  ),

                  SettingTile(
                    title: 'Help & FAQs',
                    iconData: Icons.help,
                    onTap: () {},
                  ),

                  SettingTile(
                    title: 'About TrashTrackr',
                    iconData: Icons.info,
                    onTap: () {},
                  ),

                  SettingTile(
                    title: 'Logout',
                    iconData: Icons.logout,
                    color: kRed,
                    onTap: _logout,
                  ),
                ],
              ),

              // Flexible Offset
              Flexible(child: SizedBox(height: 120)),

              // Delete Account Butotn
              RoundedRectangleButton(
                backgroundColor: kRed,
                title: 'Delete Account',
                onPressed: _deleteAccount,
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