import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/maps/frontend/map_screen.dart';

class DisposalLocationButton extends StatelessWidget {

  const DisposalLocationButton({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapScreen()),
          ),

      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/covers/map.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
