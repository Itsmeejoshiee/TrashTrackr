import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';

class PlaceholderAlert {
  void showPlaceholderConstructionAlert(BuildContext context) {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "We're working on this feature!",
      image: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
        child: Image.asset(
          "assets/images/components/no_construction.png",
          width: 110,
        ),
      ),
      desc:
          "We're working on this feature — just cleaning things up before it's ready!",
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kAvocado,
          radius: BorderRadius.circular(30),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Okay!',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }
}
