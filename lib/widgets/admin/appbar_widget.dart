import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/notification.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': "Brinda Karthik", // John Doe
            'company': "OA Puducherry", // Stokes and Sons
            'age': 25 // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(1), bottomRight: Radius.circular(1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  "images/logo.png",
                  width: 75,
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 13),
                  child: Text(
                    "OCEAN ACADEMY".toLowerCase(),
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF0091D2),
                        fontFamily: 'Ubuntu'),
                  ),
                )
              ],
            ),
            Row(
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: addUser,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.circle,
                              size: 14,
                              color: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Admin",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  color: Color(0xFF0090E9),
                ),
                SizedBox(
                  width: 60.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onTap: () {
                            Provider.of<Routing>(context, listen: false)
                                .updateRouting(widget: SendNotification());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Icon(
                              FontAwesomeIcons.bell,
                              size: 30,
                              color: Color(0xff707070),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 15,
                        child: Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
