import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/filter_menu.dart';

class DashboardSearchBar extends StatefulWidget {
  const DashboardSearchBar({
    super.key,
    required this.controller,
    this.hintText,
    this.iconData = Icons.person,
    this.obscureText = false,
    this.margin,
    required this.onSearch,
    this.onFilterTap,
    this.onSubmit,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData iconData;
  final bool obscureText;
  final EdgeInsets? margin;
  final VoidCallback onSearch;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onSubmit;

  @override
  State<DashboardSearchBar> createState() => _DashboardSearchBarState();
}

class _DashboardSearchBarState extends State<DashboardSearchBar>
    with TickerProviderStateMixin {
  bool isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 15),
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(0.00, 0.00),
              end: Alignment(1.00, 1.00),
              colors: [Colors.white, Color(0xFFEAEAEA)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0xE5DDDDDD),
                blurRadius: 13,
                offset: Offset(5, 5),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color(0x33DDDDDD),
                blurRadius: 10,
                offset: Offset(-5, 5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            onSubmitted: widget.onSubmit,
            style: kTitleMedium.copyWith(
              color: const Color(0xFF616468),
              fontWeight: FontWeight.bold,
            ),
            cursorColor: const Color(0xFF616468),
            cursorHeight: 20,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF616468),
                  size: 23,
                ),
                onPressed: widget.onSearch,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune_outlined, color: Color(0xFF616468)),
                onPressed: () {
                  setState(() {
                    isFilterVisible = !isFilterVisible;
                  });
                },
              ),
              contentPadding: const EdgeInsets.only(top: 11),
              hintText: widget.hintText,
              hintStyle: kTitleMedium.copyWith(
                color: const Color(0xFF616468),
                fontWeight: FontWeight.bold,
              ),
            ),
            obscureText: widget.obscureText,
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isFilterVisible ? const FilterMenu() : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
