import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/settings/backend/frontend/widgets/list_tiles/switch_setting_tile.dart';
import 'package:trashtrackr/features/settings/backend/frontend/widgets/list_tiles/setting_tile_group.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _locationAccess = true;
  bool _cameraAccess = true;
  bool _saveDisposalHistory = true;
  bool _shareAppActivity = true;
  bool _accountVisibility = true;
  bool _commentsOnPost = true;

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
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location & Camera Acccess',
                style: kTitleMedium.copyWith(fontWeight: FontWeight.w900),
              ),

              SettingTileGroup(
                children: [
                  SwitchSettingTile(
                    title: 'Allow Location Access',
                    iconData: Icons.location_on_rounded,
                    value: _locationAccess,
                    onChanged: (value) {
                      setState(() {
                        _locationAccess = value;
                      });
                    },
                  ),

                  SwitchSettingTile(
                    title: 'Allow Camera Access',
                    iconData: Icons.camera_alt_rounded,
                    value: _cameraAccess,
                    onChanged: (value) {
                      setState(() {
                        _cameraAccess = value;
                      });
                    },
                  ),
                ],
              ),

              Text(
                'Data Collection & Personal Info',
                style: kTitleMedium.copyWith(fontWeight: FontWeight.w900),
              ),

              SettingTileGroup(
                children: [
                  SwitchSettingTile(
                    title: 'Save Disposal History',
                    subtitle: "Keeps track of what items you've disposed of.",
                    iconData: Icons.history,
                    value: _saveDisposalHistory,
                    onChanged: (value) {
                      setState(() {
                        _saveDisposalHistory = value;
                      });
                    },
                  ),

                  SwitchSettingTile(
                    title: 'Share App Activity',
                    subtitle:
                        'Helps improve accuracy and features. No personal data is shared externally.',
                    iconData: Icons.monitor_heart_rounded,
                    value: _shareAppActivity,
                    onChanged: (value) {
                      setState(() {
                        _shareAppActivity = value;
                      });
                    },
                  ),
                ],
              ),

              Text(
                'Profile & Community',
                style: kTitleMedium.copyWith(fontWeight: FontWeight.w900),
              ),

              SettingTileGroup(
                children: [
                  SwitchSettingTile(
                    title: 'Account Visibility',
                    iconData: Icons.person,
                    value: _accountVisibility,
                    onChanged: (value) {
                      setState(() {
                        _accountVisibility = value;
                      });
                    },
                  ),

                  SwitchSettingTile(
                    title: 'Allow Comments on My Posts',
                    iconData: Icons.message,
                    value: _commentsOnPost,
                    onChanged: (value) {
                      setState(() {
                        _commentsOnPost = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
