import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/profile/post_widget.dart';
import 'package:trashtrackr/core/widgets/profile/wastelog_widget.dart';
import 'package:trashtrackr/core/widgets/profile/cleanup_widget.dart';

enum ProfileSection { posts, wasteLog, cleanup }

class ProfileSectionView extends StatelessWidget {
  final ProfileSection selectedSection;

  const ProfileSectionView({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context) {
    switch (selectedSection) {
      case ProfileSection.posts:
        return PostWidget(key: ValueKey('posts'));
      case ProfileSection.wasteLog:
        return WastelogWidget(key: ValueKey('wastelog'));
      case ProfileSection.cleanup:
        return CleanupWidget(key: ValueKey('cleanup'));
    }
  }
}
