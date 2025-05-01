import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class FaqTile extends StatefulWidget {
  const FaqTile({super.key, required this.title, this.description});

  final String title;
  final String? description;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {

  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, const Color(0xFFF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xE5E0E0E0),
            blurRadius: 13,
            offset: Offset(5, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(-5, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        iconColor: kAvocado,
        collapsedIconColor: kAvocado,
        onExpansionChanged: (value) {
          setState(() => _isCollapsed = value);
        },
        title: Text(
          widget.title,
          style: kBodyMedium.copyWith(
            color: (_isCollapsed) ? kAvocado : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [Padding(
          padding: const EdgeInsets.only(left: 18, right: 30, bottom: 20),
          child: Text(widget.description!, style: kBodySmall,),
        )],
      ),
    );
  }
}