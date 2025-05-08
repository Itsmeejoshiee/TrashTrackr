import 'package:flutter/material.dart';

class RecyclingGuideCarousel extends StatelessWidget {
  const RecyclingGuideCarousel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [SizedBox(width: 32), ...children],
      ),
    );
  }
}

