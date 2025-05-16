import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class PlaceholderAlert {
  void showPlaceholderAlert(BuildContext context) {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Are you sure you want\nto delete your account?",
      desc:
          "We're sad to see you leave! Deleting your TrashTrackr account will permanently erase your data, including your streaks, badges, posts, and waste log.",
      image: Image.asset("assets/images/icons/red_delete_icon.png", width: 110),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: kRed,
          radius: BorderRadius.circular(30),
          onPressed: () {
            // delete logic here
          },
          child: Text(
            'Delete',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }
}
