import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/certificate.dart';
import 'package:ocean_live/screens/admin/client.dart';
import 'package:ocean_live/screens/admin/company.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:ocean_live/screens/admin/mentor.dart';
import 'package:ocean_live/screens/admin/notification.dart';
import 'package:ocean_live/screens/admin/upcoming_batch.dart';
import 'package:ocean_live/screens/admin/video.dart';
import 'package:ocean_live/widgets/admin/appbar_widget.dart';
import 'package:provider/provider.dart';

import 'Details.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  static Map menuColor = {
    "Courses": true,
    "Payment Details": false,
    "Payment Details": false,
    "Staff Details": false,
    "Student Details": false,
    "Upcoming Batches": false,
    "Notifications": false,
    "Client": false,
    "Company": false,
    "Video": false,
    "Mentor": false,
    "Certificate": false,
  };

  Widget contentWidget = Details(text: "staff");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            padding: EdgeInsets.only(top: 10.0),
            color: Color(0xFFF2F3F5),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                menuItem(
                    text: "Courses",
                    iconData: FontAwesomeIcons.laptop,
                    widget: Course()),
                menuItem(
                    text: "Payment Details",
                    iconData: FontAwesomeIcons.creditCard,
                    widget: Details(text: "payment")),
                menuItem(
                    text: "Staff Details",
                    iconData: FontAwesomeIcons.addressCard,
                    widget: Details(text: "staff")),
                menuItem(
                    text: "Student Details",
                    iconData: FontAwesomeIcons.users,
                    widget: Details(text: "student")),
                menuItem(
                    text: "Upcoming Batches",
                    iconData: FontAwesomeIcons.graduationCap,
                    widget: UpcomingBatch()),
                menuItem(
                    text: "Notifications",
                    iconData: FontAwesomeIcons.bell,
                    widget: SendNotification()),
                menuItem(
                    text: "Client",
                    iconData: FontAwesomeIcons.user,
                    widget: Client()),
                menuItem(
                    text: "Company",
                    iconData: FontAwesomeIcons.building,
                    widget: Company()),
                menuItem(
                    text: "Video",
                    iconData: FontAwesomeIcons.video,
                    widget: Video()),
                menuItem(
                    text: "Mentor",
                    iconData: FontAwesomeIcons.elementor,
                    widget: Mentor()),
                menuItem(
                    text: "Certificate",
                    iconData: FontAwesomeIcons.certificate,
                    widget: Certificate()),
              ],
            ),
          ),
          Container(
            child: Consumer<Routing>(builder: (context, routing, child) {
              return routing.route;
            }),
          )
        ],
      ),
    );
  }

  MouseRegion menuItem({text, iconData, widget}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            //   contentWidget = widget;

            menuColor.updateAll((key, value) => menuColor[key] = false);
            menuColor[text] = true;

            Provider.of<Routing>(context, listen: false)
                .updateRouting(widget: widget);
          });
        },
        child: menuList(
          icon: iconData,
          text: text,
        ),
      ),
    );
  }

  Column menuList({text, icon}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 50,
                child: Icon(
                  icon,
                  size: 20,
                  color: menuColor[text] ? adminTextColor : adminDefaultText,
                )),
            Text(
              text,
              style: TextStyle(
                  textBaseline: TextBaseline.ideographic,
                  color: menuColor[text] ? adminTextColor : adminDefaultText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        SizedBox(
          height: 30.0,
        )
      ],
    );
  }
}
