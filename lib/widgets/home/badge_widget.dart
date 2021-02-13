import 'package:flutter/material.dart';
import 'package:ocean_live/constants.dart';

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final String heading, title;
  BadgeWidget({this.icon, this.heading, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 50.0,
          color: textColor,
        ),
        Text(
          heading,
          style: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
