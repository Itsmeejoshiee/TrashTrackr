import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, 
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, Color(0xFFEAEAEA)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.03)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xE5DDDDDD),
            blurRadius: 13,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: Color(0x33DDDDDD),
            blurRadius: 10,
            offset: Offset(5, -5),
          ),
          BoxShadow(
            color: Color(0x33DDDDDD),
            blurRadius: 10,
            offset: Offset(-5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔍 Search Icon from asset
          Image.asset(
            'assets/images/icons/search.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          // Expanded text field
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search logs...',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // ⚙️ Filter Icon from asset
          GestureDetector(
            onTap: () {
              // TODO: Add filter action
            },
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
