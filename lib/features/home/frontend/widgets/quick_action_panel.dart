import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class QuickActionPanel extends StatelessWidget {
  const QuickActionPanel({
    super.key,
    required this.onWasteStats,
    required this.onCommunity,
    required this.onDisposalLoc,
    required this.onGames,
    required this.onLogDisposal,
    required this.onScan,
  });

  final VoidCallback onWasteStats;
  final VoidCallback onCommunity;
  final VoidCallback onDisposalLoc;
  final VoidCallback onGames;
  final VoidCallback onLogDisposal;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        QuickActionButton(
          imagePath: 'assets/images/icons/waste_stats.png',
          onPressed: onWasteStats,
        ),
        QuickActionButton(
          imagePath: 'assets/images/icons/community.png',
          onPressed: onCommunity,
        ),
        QuickActionButton(
          imagePath: 'assets/images/icons/disposal_locations.png',
          onPressed: onDisposalLoc,
        ),
        QuickActionButton(
          imagePath: 'assets/images/icons/games.png',
          onPressed: onGames,
        ),
        QuickActionButton(
          imagePath: 'assets/images/icons/log_disposal.png',
          onPressed: onLogDisposal,
        ),
        QuickActionButton(
          imagePath: 'assets/images/icons/scan.png',
          onPressed: onScan,
        ),
      ],
    );
  }
}

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  final String imagePath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(onTap: onPressed, child: Image.asset(imagePath)),
    );
  }
}
