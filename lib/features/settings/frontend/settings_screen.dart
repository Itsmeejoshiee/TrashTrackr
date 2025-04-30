import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/edit_profile_picture_button.dart';
import 'package:trashtrackr/core/widgets/list_tiles/setting_tile.dart';
import 'package:trashtrackr/core/widgets/list_tiles/switch_setting_tile.dart';
import 'package:trashtrackr/core/widgets/list_tiles/setting_tile_group.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _notifsEnabled = true;

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
              EditProfilePictureButton(
                onPressed: () {},
              ),
        
              Text(
                'Ella Green',
                style: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
        
              // Offset
              SizedBox(height: 35),
        
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


                  SettingTile(title: 'Privacy Options', iconData: Icons.shield, onTap: () {}),

                  SettingTile(title: 'Help & FAQs', iconData: Icons.help, onTap: () {}),

                  SettingTile(title: 'About TrashTrackr', iconData: Icons.info, onTap: () {}),

                ],
              ),
        
              // Flexible Offset
              Flexible(child: SizedBox(height: 120)),
        
              // Delete Account Butotn
              RoundedRectangleButton(
                backgroundColor: kRed,
                title: 'Delete Account',
                onPressed: () {},
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