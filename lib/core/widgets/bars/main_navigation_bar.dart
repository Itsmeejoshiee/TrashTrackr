import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';


enum NavRoute {
  home,
  feed,
  badge,
  profile,
}

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.activeRoute,
    required this.onSelect,
  });

  final NavRoute activeRoute;
  final void Function(NavRoute) onSelect;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: kLightGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavigationItem(
                  label: 'Home',
                  iconData: Icons.home_outlined,
                  isSelected: (activeRoute == NavRoute.home),
                  onSelect: () => onSelect(NavRoute.home),
                ),
                NavigationItem(
                  label: 'Feed',
                  iconData: Icons.newspaper_outlined,
                  isSelected: (activeRoute == NavRoute.feed),
                  onSelect: () => onSelect(NavRoute.feed),
                ),
              ],
            ),
          ),

          SizedBox(width: 60),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavigationItem(
                  label: 'Badge',
                  iconData: Icons.star_border_outlined,
                  isSelected: (activeRoute == NavRoute.badge),
                  onSelect: () => onSelect(NavRoute.badge),
                ),
                NavigationItem(
                  label: 'Profile',
                  iconData: Icons.person_outline,
                  isSelected: (activeRoute == NavRoute.profile),
                  onSelect: () => onSelect(NavRoute.profile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.isSelected,
    required this.onSelect,
  });

  final IconData iconData;
  final String label;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Column(
        children: [
          Icon(iconData, color: (isSelected) ? kAppleGreen : Colors.black),
          Text(
            label,
            style: kPoppinsBodyMedium.copyWith(
              color: (isSelected) ? kAppleGreen : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}