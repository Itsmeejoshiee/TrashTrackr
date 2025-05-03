import 'package:flutter/material.dart';

class SettingTileGroup extends StatelessWidget {
  const SettingTileGroup({super.key, required this.children});

  final List<Widget> children;

  List<Widget> _buildTiles() {
    List<Widget> tiles = [];

    for (int i = 0; i < children.length - 1; i++) {
      tiles.add(children[i]);
      tiles.add(
        Container(
          width: double.infinity,
          height: 1,
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          color: Colors.black26,
        ),
      );
    }
    tiles.add(children[children.length - 1]);

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xE5E6E6E6),
            blurRadius: 13,
            offset: Offset(5, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E6E6E6),
            blurRadius: 10,
            offset: Offset(-5, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(children: _buildTiles()),
    );
  }
}
