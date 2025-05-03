class UserBadgeModel {
  String badgeImageUrl;
  String badgeName;
  String? badgeDescription;

  UserBadgeModel({
    required this.badgeImageUrl,
    required this.badgeName,
    this.badgeDescription,
  });
}
