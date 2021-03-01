import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification/send_notification.dart';

final _firestore = FirebaseFirestore.instance;

class SendNotification extends StatefulWidget {
  // String studentid;
  // SendNotification({this.studentid});
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  Widget customWidget;

  // void studentNotify() async {
  //   print("${ParticularStudent.dropdownValue}dropdownnnnnnnnnnn");
  //   await for (var snapshot in _firestore
  //       .collection('users')
  //       .where("name", isEqualTo: ParticularStudent.dropdownValue)
  //       .snapshots(includeMetadataChanges: true)) {
  //     for (var message in snapshot.docs) {
  //       //print(message.documentID);
  //       setState(() {
  //         widget.studentid = message.documentID;
  //       });
  //       print("${widget.studentid}studentjjjjjjjjjjjjjjjjjjjjjjj");
  //     }
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    //customWidget = ViewNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                aCustomButtom(
                    text: "Send Notification",
                    iconData: FontAwesomeIcons.bell,
                    buttonClick: () {
                      Provider.of<Routing>(context, listen: false)
                          .updateRouting(widget: SendNotifications());
                    },
                    fontSize: 22,
                    iconSize: 19)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ViewNotification(),
          ],
        ),
      ),
    );
  }
}

class ViewNotification extends StatefulWidget {
  const ViewNotification({
    Key key,
  }) : super(key: key);

  @override
  _ViewNotificationState createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  List<Widget> usersList = [];

  var users;
  var name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userListId();
  }

  void userListId() async {
    print("------------------------------------");
    await for (var snapshot in _firestore
        .collection('new users')
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        users = message.documentID;
        // usersList.add(users);
        getUserName(users);

        // getFunction(users);
      }
    }
  }

  getUserName(String userNumber) async {
    await for (var snapshot in _firestore
        .collection('new users')
        .where("Phone Number", isEqualTo: userNumber)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        name = message.data()["First Name"];

        getNotification(userNumber, name);
      }
    }
  }

  getNotification(String userNumber, String userName) async {
    await for (var snapshot in _firestore
        .collection('new users')
        .doc(userNumber)
        .collection("notification")
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        var description = message.data()['description'];
        print(userName);
        print(userNumber);
        print(description);
        Container userNotification = Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          width: 1300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0XFFF7F7F7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                // spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002C47)),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Color(0xFF555454)),
              ),
            ],
          ),
        );
        usersList.add(userNotification);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [],
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
