import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String title;
  TextWidget({this.title});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 25,
          color: const Color(0xff555555),
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
