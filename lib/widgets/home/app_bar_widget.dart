import 'package:flutter/material.dart';

import '../../constants.dart';
import 'menu_flat_button_widget.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1200),
      color: primaryColor,
      height: 96.0,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 62.0, vertical: 26.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Image.asset("images/logo.png"),
          ),
          Row(
            children: [
              MenuFlatButton(
                title: "About Us",
              ),
              SizedBox(
                width: 50.0,
              ),
              MenuFlatButton(
                title: "Services",
              ),
              SizedBox(
                width: 50.0,
              ),
              MenuFlatButton(
                title: "Courses",
              ),
              SizedBox(
                width: 50.0,
              ),
              MenuFlatButton(
                title: "Contact Us",
              ),
              SizedBox(
                width: 50.0,
              ),
              MaterialButton(
                color: Color(0xFF0091D2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
