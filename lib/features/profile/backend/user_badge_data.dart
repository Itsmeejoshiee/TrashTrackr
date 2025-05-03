import 'package:trashtrackr/features/profile/backend/user_badge_model.dart';

class UserBadgeData {
  List<UserBadgeModel> userBadges = [
    UserBadgeModel(
      badgeImageUrl: 'assets/images/sample_badge.png',
      badgeName: 'Green Streaker',
    ),
    UserBadgeModel(
      badgeImageUrl: 'assets/images/sample_badge.png',
      badgeName: 'Eco Champion',
    ),
    UserBadgeModel(
      badgeImageUrl: 'assets/images/sample_badge.png',
      badgeName: 'First Toss',
    ),
  ];
}
