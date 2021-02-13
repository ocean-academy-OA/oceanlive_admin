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
    customWidget = ViewNotification();
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

class ViewNotification extends StatelessWidget {
  const ViewNotification({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0XFFF7F7F7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
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
            "Guna Salini",
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002C47)),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.",
            style: TextStyle(fontSize: 16, color: Color(0xFF555454)),
          ),
        ],
      ),
    );
  }
}
