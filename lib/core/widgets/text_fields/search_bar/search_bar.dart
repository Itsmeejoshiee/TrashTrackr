import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart'; // Import constants.dart

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleInputChange);
    super.dispose();
  }

  void _handleInputChange() {
    setState(() {
      showClearIcon = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 236, 236, 236), Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
          BoxShadow(color: Color(0xFFD6D6D6), offset: Offset(4, 4), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Image.asset('assets/images/icons/search.png', width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              cursorColor: kForestGreen, // Set the blinking cursor color
              style: kTitleMedium.copyWith(color: Colors.black), // Use Urbanist font from constants
              decoration: InputDecoration(
                hintText: 'Search logs...',
                hintStyle: kTitleSmall, // Use Urbanist font for the hint text
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (showClearIcon) ...[
            GestureDetector(
              onTap: () {
                widget.controller.clear(); // Clear the search bar
                if (widget.onChanged != null) {
                  widget.onChanged!(''); // Notify the parent widget of the reset
                }
              },
              child: const Icon(
                Icons.close, // "X" icon
                color: Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          GestureDetector(
            onTap: widget.onFilterTap, // Call the callback here
            child: Image.asset(
              'assets/images/icons/filter.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}

