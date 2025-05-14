enum BadgeType {
  greenStreaker,
  weekendWarrior,
  barcodeSleuth,
  ecoChampion,
  scannerRookie,
  zeroWasteHero,
  firstToss,
  sortingExpert,
  ecoInfluencer,
  dailyDiligent,
  plasticBuster,
  cleanupCaptain,
  quizMaster,
  trashTrackrOg,
}

const Map<BadgeType, String> badgePath = {
  BadgeType.greenStreaker: 'green_streaker.png',
  BadgeType.weekendWarrior: 'weekend_warrior.png',
  BadgeType.barcodeSleuth: 'barcode_sleuth.png',
  BadgeType.ecoChampion: 'eco_champion.png',
  BadgeType.scannerRookie: 'scanner_rookie.png',
  BadgeType.zeroWasteHero: 'zero_waste_hero.png',
  BadgeType.firstToss: 'first_toss.png',
  BadgeType.sortingExpert: 'sorting_expert.png',
  BadgeType.ecoInfluencer: 'eco_influencer.png',
  BadgeType.dailyDiligent: 'daily_diligent.png',
  BadgeType.plasticBuster: 'plastic_buster.png',
  BadgeType.cleanupCaptain: 'cleanup_captain.png',
  BadgeType.quizMaster: 'quiz_master.png',
  BadgeType.trashTrackrOg: 'trash_trackr_og.png',
};

const Map<BadgeType, String> badgeTitle = {
  BadgeType.greenStreaker: 'Green Streaker',
  BadgeType.weekendWarrior: 'Weekend Warrior',
  BadgeType.barcodeSleuth: 'Bar code Sleuth',
  BadgeType.ecoChampion: 'Eco Champion',
  BadgeType.scannerRookie: 'Scanner Rookie',
  BadgeType.zeroWasteHero: 'Zero Waste Hero',
  BadgeType.firstToss: 'First Toss',
  BadgeType.sortingExpert: 'Sorting Expert',
  BadgeType.ecoInfluencer: 'Eco Influencer',
  BadgeType.dailyDiligent: 'Daily Diligent',
  BadgeType.plasticBuster: 'Plastic Buster',
  BadgeType.cleanupCaptain: 'Clean-up Captain',
  BadgeType.quizMaster: 'Quiz Master',
  BadgeType.trashTrackrOg: 'TrashTrackr OG',
};

const Map<BadgeType, String> badgeDesc = {
  BadgeType.greenStreaker: 'Reach a 7-day streak',
  BadgeType.weekendWarrior: 'Use the app on both a Saturday and a Sunday',
  BadgeType.barcodeSleuth: 'Scan 10 product barcodes',
  BadgeType.ecoChampion: 'Hit a 30-day milestone',
  BadgeType.scannerRookie: 'Scan 10 items',
  BadgeType.zeroWasteHero: 'Log a waste-free day',
  BadgeType.firstToss: 'Classify your first item correctly',
  BadgeType.sortingExpert: 'Get 100 correct classifications',
  BadgeType.ecoInfluencer: 'Share the app or share one of your achievements',
  BadgeType.dailyDiligent: 'Use the app 5 days in a row',
  BadgeType.plasticBuster: 'Properly dispose of 20 plastic items',
  BadgeType.cleanupCaptain: 'Join or log a local clean-up activity',
  BadgeType.quizMaster: 'Ace 10 eco quizzes with perfect scores',
  BadgeType.trashTrackrOg: 'Install and use the app in its first month',
};

const Map<int, BadgeType> badgeId = {
  1: BadgeType.greenStreaker,
  2: BadgeType.weekendWarrior,
  3: BadgeType.barcodeSleuth,
  4: BadgeType.ecoChampion,
  5: BadgeType.scannerRookie,
  6: BadgeType.zeroWasteHero,
  7: BadgeType.firstToss,
  8: BadgeType.sortingExpert,
  9: BadgeType.ecoInfluencer,
  10: BadgeType.dailyDiligent,
  11: BadgeType.plasticBuster,
  12: BadgeType.cleanupCaptain,
  13: BadgeType.quizMaster,
  14: BadgeType.trashTrackrOg,
};


class BadgeModel {
  final int id;
  final double percent;

  BadgeModel({
    required this.id,
    required this.percent,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> data) {
    return BadgeModel(
      id: data['id'],
      percent: (data['percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'percent': percent,
    };
  }

  String get imagePath {
    final BadgeType badge = badgeId[id]!;
    return badgePath[badge]!;
  }

  String get title {
    final BadgeType badge = badgeId[id]!;
    return badgeTitle[badge]!;
  }

  String get desc {
    final BadgeType badge = badgeId[id]!;
    return badgeDesc[badge]!;
  }

  bool get isEarned => percent == 1; // Determine if the badge is earned
}