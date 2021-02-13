import 'package:flutter/material.dart';
import 'package:ocean_live/constants.dart';

class MainTitleWidget extends StatelessWidget {
  final String title;
  MainTitleWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 30.0,
          bottom: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 30,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    alignment: Alignment.centerLeft,
                    width: 800.0,
                    height: 38,
                    color: Color(0xFFD9D9D9),
                  ),
                ),
                Positioned(
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
