import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({
    super.key,
    required this.username,
    required this.onNotifs,
    required this.greetingMessage,
  });

  final String username;
  final VoidCallback onNotifs;
  final String? greetingMessage;

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            RichText(
              text: TextSpan(
                style: kHeadlineSmall.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: '${widget.greetingMessage},'),
                  TextSpan(
                    text: ' ${widget.username}!',
                    style: TextStyle(color: kAppleGreen),
                  ),
                ],
              ),
            ),
            Text('Trash it. Track it. Together!'),
          ],
        ),
        IconButton(
          onPressed: widget.onNotifs,
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}
